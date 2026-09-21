# MPX Meltdown Invulnerability Checking

SMT-LIB2 benchmarks accompanying:

> Y. Moshood, S. K. Srinivasan, N. Mathure, and A. Govindankutty,
> “Invulnerability Checking for Memory Protection Extensions Against Meltdown,”
> *2026 IEEE International Symposium on Circuits and Systems (ISCAS)*,
> 2026.
> DOI: [10.1109/ISCAS66217.2026.11562423](https://doi.org/10.1109/ISCAS66217.2026.11562423)
> [![DOI](https://zenodo.org/badge/1373949209.svg)](https://doi.org/10.5281/zenodo.22866112)

The paper is available through the DOI above. See [CITATION.cff](CITATION.cff) for citation details.

## Overview

This repository contains 16 benchmarks covering four load-store queue (LSQ) sizes: 8, 16, 32, and 64 entries. Each size includes a secure baseline and three Trojan variants: Base, Bound, and Illegal Memory Access.

## Verification scope

Each benchmark encodes an invariant-checking query for an SMT model of the corresponding configuration. Z3 checks whether the query is satisfiable:

- `unsat`: no assignment satisfies the encoded query.
- `sat`: an assignment satisfies the encoded query. The Trojan benchmarks request model values to help examine the result.

The expected result is `unsat` for each baseline and `sat` for each Trojan variant. The results apply to the supplied models and their assumptions. A satisfying assignment alone does not establish that the corresponding state is reachable during execution. See Section IV of the paper for the modeling assumptions.

## Repository structure

| Location | Contents |
|---|---|
| `benchmarks/lsq08/` | 8-entry LSQ benchmarks |
| `benchmarks/lsq16/` | 16-entry LSQ benchmarks |
| `benchmarks/lsq32/` | 32-entry LSQ benchmarks |
| `benchmarks/lsq64/` | 64-entry LSQ benchmarks |
| `scripts/run_verification.sh` | Verification script |

Each benchmark folder contains four files:

- `secure.smt2`
- `trojan_base.smt2`
- `trojan_bound.smt2`
- `trojan_illegal_access.smt2`

## Requirements

- Z3 4.15.1, installed through `z3-solver==4.15.1.0`
- Python 3 with `pip` and `venv`
- Bash and GNU coreutils

The script uses the GNU `timeout` command to limit execution time. If `timeout` is unavailable, it prints a warning and runs without enforcing timeouts.

## Installation

Run these commands from the project directory in a Bash shell:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Check the solver version:

```bash
z3 --version
```

## Running the verification

Run all 16 benchmarks:

```bash
bash scripts/run_verification.sh
```

The script runs the benchmarks sequentially, compares each result with its expected verdict, and saves the solver output and execution time.


```bash
DEFAULT_TIMEOUT_SEC=300 LONG_TIMEOUT_SEC=1800 bash scripts/run_verification.sh
```

To run a single benchmark:

```bash
z3 benchmarks/lsq08/trojan_base.smt2
```

## Output files

| Location | Contents |
|---|---|
| `results/logs/` | Solver output for each benchmark |
| `results/machine_info.txt` | Run date, solver version, and machine details |

The script overwrites its output files on subsequent runs. Copy any results you want to retain before running it again.

The script exits with status `0` when all 16 benchmarks match their expected results. It exits with status `1` if a benchmark is missing, times out, encounters a solver error, or fails to return the expected result.

## Recorded results

The supplied run records report the following results with Z3 4.15.1:

| LSQ entries | Benchmark | Expected | Result | Time (s) |
|---|---|---|---|---:|
| 8 | secure | unsat | unsat | 0.22 |
| 8 | trojan_base | sat | sat | 0.28 |
| 8 | trojan_bound | sat | sat | 0.31 |
| 8 | trojan_illegal_access | sat | sat | 0.23 |
| 16 | secure | unsat | unsat | 0.20 |
| 16 | trojan_base | sat | sat | 0.77 |
| 16 | trojan_bound | sat | sat | 1.03 |
| 16 | trojan_illegal_access | sat | sat | 0.38 |
| 32 | secure | unsat | unsat | 0.23 |
| 32 | trojan_base | sat | sat | 8.18 |
| 32 | trojan_bound | sat | sat | 2.74 |
| 32 | trojan_illegal_access | sat | sat | 16.10 |
| 64 | secure | unsat | unsat | 0.57 |
| 64 | trojan_base | sat | sat | 21.83 |
| 64 | trojan_bound | sat | sat | 16.79 |
| 64 | trojan_illegal_access | sat | sat | 180.80 |

All 16 benchmarks matched their expected results in this run.

The recorded machine configuration was an Intel Core i9-12900K with 24 hardware threads, 32 GB RAM, and Linux `5.14.0-611.16.1.el9_7.x86_64`.

Execution times vary with hardware and solver version. Correct, completed solver runs should agree on the same query. A timeout or an incomplete run does not establish a verification result.

## Acknowledgments

This work was supported by the U.S. National Science Foundation under CNS Grant No. 2117190.

## License

This code is distributed under the MIT License. See [LICENSE](LICENSE).
