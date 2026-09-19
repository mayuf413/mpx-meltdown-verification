#!/usr/bin/env bash
# Verify 16 benchmarks: four LSQ sizes, each with a baseline and three Trojans.
# Requires Bash, Python 3, and GNU coreutils on Linux.
# Usage: bash scripts/run_verification.sh [z3-binary]
# DEFAULT_TIMEOUT_SEC: timeout for most benchmarks (default: 120 seconds).
# LONG_TIMEOUT_SEC: timeout for lsq64/trojan_illegal_access (default: 900 seconds).
# Existing run output in results/ is overwritten.
set -euo pipefail
export LC_ALL=C

fail() { printf 'error: %s\n' "$*" >&2; exit 1; }
Z3="${1:-z3}"
DEFAULT_TIMEOUT_SEC="${DEFAULT_TIMEOUT_SEC:-120}"
LONG_TIMEOUT_SEC="${LONG_TIMEOUT_SEC:-900}"

for dependency in "$Z3" timeout python3 awk grep date uname; do
    command -v "$dependency" >/dev/null 2>&1 || fail "Required command not found: $dependency"
done
for seconds in "$DEFAULT_TIMEOUT_SEC" "$LONG_TIMEOUT_SEC"; do
    [[ "$seconds" =~ ^[1-9][0-9]*$ ]] || fail "Timeouts must be positive whole seconds."
done
solver_version=$("$Z3" --version) || fail "Cannot obtain solver version."
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$ROOT/results"
LOG_DIR="$RESULTS_DIR/logs"
SUMMARY_CSV="$RESULTS_DIR/summary.csv"
MACHINE_INFO="$RESULTS_DIR/machine_info.txt"
mkdir -p "$LOG_DIR" || fail "Cannot create log directory: $LOG_DIR"

# Record the run date, solver version, and machine details.
{
    printf 'run_date_utc: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    printf 'z3_version: %s\n' "$solver_version"
    printf 'uname: %s\n' "$(uname -srvmo)"
    if [[ -r /proc/cpuinfo ]]; then
        awk -F ': ' '/^model name/ {print "cpu_model: " $2; exit}' /proc/cpuinfo
        awk '/^processor/ {n++} END {print "cpu_count: " n+0}' /proc/cpuinfo
    fi
    if [[ -r /proc/meminfo ]]; then
        awk '/^MemTotal:/ {print "mem_total: " $2 " " $3}' /proc/meminfo
    fi
} > "$MACHINE_INFO"

# LSQ size, benchmark name, expected result.
BENCHMARKS="
08 secure unsat
08 trojan_base sat
08 trojan_bound sat
08 trojan_illegal_access sat
16 secure unsat
16 trojan_base sat
16 trojan_bound sat
16 trojan_illegal_access sat
32 secure unsat
32 trojan_base sat
32 trojan_bound sat
32 trojan_illegal_access sat
64 secure unsat
64 trojan_base sat
64 trojan_bound sat
64 trojan_illegal_access sat
"
now() { python3 -c 'import time; print(time.monotonic())'; }
printf '%-6s %-24s %-9s %-16s %9s\n' LSQ Benchmark Expected Status 'Time(s)'
printf 'lsq,benchmark,expected,result,verdict,time_s,exit_code\n' > "$SUMMARY_CSV"
total=0
ok=0
overall_status=0
while read -r size role expected; do
    [[ -z "${size:-}" ]] && continue
    total=$((total + 1))
    file="$ROOT/benchmarks/lsq${size}/${role}.smt2"
    log="$LOG_DIR/lsq${size}_${role}.log"
    if [[ ! -f "$file" ]]; then
        printf 'Missing benchmark: %s\n' "$file" > "$log"
        printf '%-6s %-24s %-9s %-16s %9s\n' "$size" "$role" "$expected" MISSING_FILE '-'
        printf '%s,%s,%s,,MISSING_FILE,,\n' "$size" "$role" "$expected" >> "$SUMMARY_CSV"
        overall_status=1
        continue
    fi
    timeout_sec="$DEFAULT_TIMEOUT_SEC"
    if [[ "$size" == 64 && "$role" == trojan_illegal_access ]]; then
        timeout_sec="$LONG_TIMEOUT_SEC"
    fi
    start=$(now)
    rc=0
    timeout --kill-after=5s "${timeout_sec}s" "$Z3" "$file" > "$log" 2>&1 || rc=$?
    end=$(now)
    elapsed=$(awk -v a="$start" -v b="$end" 'BEGIN {printf "%.2f", b-a}')
    result=$(awk '/^(sat|unsat|unknown)\r?$/ {sub(/\r$/, ""); print; exit}' "$log")
    count=$(awk '/^(sat|unsat|unknown)\r?$/ {n++} END {print n+0}' "$log")
    if [[ "$rc" -eq 124 ]]; then
        verdict=TIMEOUT
    elif [[ "$rc" -eq 137 ]]; then
        # SIGKILL may follow a timeout or another external termination.
        verdict=KILLED
    elif [[ "$rc" -ne 0 ]]; then
        verdict=SOLVER_ERROR
    elif grep -Eq '^[[:space:]]*\(error' "$log"; then
        verdict=SOLVER_ERROR
    elif [[ "$count" -ne 1 ]]; then
        verdict=UNKNOWN_OUTPUT
    elif [[ "$result" == unknown ]]; then
        verdict=UNKNOWN
    elif [[ "$result" == "$expected" ]]; then
        verdict=MATCH
        ok=$((ok + 1))
    else
        verdict=MISMATCH
    fi
    [[ "$verdict" == MATCH ]] || overall_status=1
    printf '%-6s %-24s %-9s %-16s %9s\n' "$size" "$role" "$expected" "$verdict" "$elapsed"
    printf '%s,%s,%s,%s,%s,%s,%s\n' "$size" "$role" "$expected" "$result" "$verdict" "$elapsed" "$rc" >> "$SUMMARY_CSV"
done <<< "$BENCHMARKS"
printf '\n%s / %s benchmarks matched their expected results.\n' "$ok" "$total"
printf 'Logs: %s\nSummary: %s\nMachine details: %s\n' "$LOG_DIR" "$SUMMARY_CSV" "$MACHINE_INFO"
if [[ "$overall_status" -eq 0 ]]; then
    printf 'RESULT: all 16 benchmarks matched their expected results.\n'
else
    printf 'RESULT: failed or incomplete; see the summary and logs.\n' >&2
fi
exit "$overall_status"
