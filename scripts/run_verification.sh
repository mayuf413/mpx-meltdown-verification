#!/usr/bin/env bash
# Runs the z3 MPX Meltdown Invulnerability Invariant checks for every benchmark
# present in this repository, compares each result against its expected
# verdict, and reports PASS/MISMATCH/MISSING/TIMEOUT/SOLVER_ERROR.
#
# This script checks the 16 benchmarks that exist in this repository:
# four LSQ sizes (8/16/32/64 entries), each with a Secure baseline and
# three Trojan variants (Base, Bound, Illegal Memory Access).
#
# Usage: ./scripts/run_verification.sh [z3-binary]
# Env vars:
#   DEFAULT_TIMEOUT_SEC  - timeout for most benchmarks (default: 120)
#   LONG_TIMEOUT_SEC     - timeout for the known-slow 64-entry Illegal Memory
#                          Access Trojan benchmark (default: 900)
set -u

Z3="${1:-z3}"
DEFAULT_TIMEOUT_SEC="${DEFAULT_TIMEOUT_SEC:-120}"
LONG_TIMEOUT_SEC="${LONG_TIMEOUT_SEC:-900}"

if ! command -v "$Z3" >/dev/null 2>&1; then
    echo "error: '$Z3' not found on PATH. Install with: pip install z3-solver==4.15.1.0" >&2
    exit 1
fi

HAVE_TIMEOUT=1
if ! command -v timeout >/dev/null 2>&1; then
    HAVE_TIMEOUT=0
    echo "warning: 'timeout' command not found (GNU coreutils) — timeouts will NOT be enforced." >&2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$ROOT/results"
LOG_DIR="$RESULTS_DIR/logs"
SUMMARY_CSV="$RESULTS_DIR/summary.csv"
MACHINE_INFO="$RESULTS_DIR/machine_info.txt"
mkdir -p "$LOG_DIR"

# --- Record machine / solver details (goes in the results dir, not the repo) ---
{
    echo "run_date_utc: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "z3_version: $("$Z3" --version 2>/dev/null | head -1)"
    echo "uname: $(uname -srvmo 2>/dev/null)"  # kernel/release/version/machine/os — deliberately omits hostname
    if [ -r /proc/cpuinfo ]; then
        echo "cpu_model: $(grep -m1 'model name' /proc/cpuinfo | sed 's/^.*: //')"
        echo "cpu_count: $(grep -c '^processor' /proc/cpuinfo)"
    fi
    if [ -r /proc/meminfo ]; then
        echo "mem_total: $(grep -m1 MemTotal /proc/meminfo)"
    fi
} > "$MACHINE_INFO"

# --- Benchmark manifest: size role expected_verdict ---
# expected_verdict is what the MPX Invulnerability Invariant query must
# return for this benchmark to match the paper's classification:
#   unsat = invariant holds  = "Secure" / paper's "P"
#   sat   = invariant fails  = counterexample exists / paper's "C"
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

printf "%-8s %-24s %-10s %-18s %10s\n" "LSQ" "Benchmark" "Expected" "Result" "Time(s)"
printf "%-8s %-24s %-10s %-18s %10s\n" "---" "---------" "--------" "------" "-------"
echo "lsq,benchmark,expected,result,verdict,time_s,exit_code" > "$SUMMARY_CSV"

total=0
ok=0
overall_status=0

while read -r size role expected; do
    [ -z "${size:-}" ] && continue
    total=$((total + 1))
    file="$ROOT/benchmarks/lsq${size}/${role}.smt2"
    log="$LOG_DIR/lsq${size}_${role}.log"

    if [ ! -f "$file" ]; then
        printf "%-8s %-24s %-10s %-18s %10s\n" "$size" "$role" "$expected" "MISSING_FILE" "-"
        echo "$size,$role,$expected,,MISSING_FILE,,-" >> "$SUMMARY_CSV"
        overall_status=1
        continue
    fi

    timeout_sec="$DEFAULT_TIMEOUT_SEC"
    if [ "$size" = "64" ] && [ "$role" = "trojan_illegal_access" ]; then
        timeout_sec="$LONG_TIMEOUT_SEC"
    fi

    start=$(date +%s.%N)
    if [ "$HAVE_TIMEOUT" -eq 1 ]; then
        out=$(timeout "${timeout_sec}s" "$Z3" "$file" 2>&1)
        rc=$?
    else
        out=$("$Z3" "$file" 2>&1)
        rc=$?
    fi
    end=$(date +%s.%N)
    elapsed=$(awk -v a="$start" -v b="$end" 'BEGIN{printf "%.2f", b-a}')
    printf "%s\n" "$out" > "$log"

    if [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ]; then
        result="TIMEOUT"
        verdict="INCOMPLETE"
        overall_status=1
    elif [ "$rc" -ne 0 ]; then
        result="SOLVER_ERROR"
        verdict="INCOMPLETE"
        overall_status=1
    else
        first_line=$(printf "%s" "$out" | head -1 | tr -d '\r')
        case "$first_line" in
            sat|unsat) result="$first_line" ;;
            *) result="UNKNOWN_OUTPUT" ;;
        esac
        if [ "$result" = "$expected" ]; then
            verdict="MATCH"
            ok=$((ok + 1))
        else
            verdict="MISMATCH"
            overall_status=1
        fi
    fi

    display_result="$result"
    [ "$verdict" = "MISMATCH" ] && display_result="$result (expected $expected)"
    printf "%-8s %-24s %-10s %-18s %10s\n" "$size" "$role" "$expected" "$display_result" "$elapsed"
    echo "$size,$role,$expected,$result,$verdict,$elapsed,$rc" >> "$SUMMARY_CSV"
done <<< "$BENCHMARKS"

echo
echo "$ok / $total benchmarks matched their expected verdict."
echo "Full per-benchmark solver output: $LOG_DIR/"
echo "Machine/solver details: $MACHINE_INFO"
echo "Machine-readable summary: $SUMMARY_CSV"

if [ "$overall_status" -ne 0 ]; then
    echo "RESULT: FAILED or INCOMPLETE — see MISMATCH/MISSING_FILE/TIMEOUT/SOLVER_ERROR rows above." >&2
else
    echo "RESULT: all present benchmarks matched their expected verdict."
fi

exit "$overall_status"
