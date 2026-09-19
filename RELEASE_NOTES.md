# Release Notes

## v1.0.0 — Initial release

SMT-LIB2 benchmarks accompanying:

> Y. Moshood, S. K. Srinivasan, N. Mathure, and A. Govindankutty,
> “Invulnerability Checking for Memory Protection Extensions Against Meltdown,”
> 2026 IEEE ISCAS, pp. 2021–2025.
> DOI: [10.1109/ISCAS66217.2026.11562423](https://doi.org/10.1109/ISCAS66217.2026.11562423)

### Contents

- 16 benchmarks covering four load-store queue sizes: 8, 16, 32, and
  64 entries. Each size includes a secure baseline and three Trojan
  variants: Base, Bound, and Illegal Memory Access.
- A verification script (`scripts/run_verification.sh`) that runs the
  benchmarks, checks expected results, applies timeouts, and records
  solver output, execution times, and machine details. The script
  returns a nonzero exit status on a mismatch, missing file, timeout,
  or solver error.

### Verification results

The recorded run used Z3 4.15.1 (`z3-solver==4.15.1.0`).
All 16 benchmarks matched their expected results: `unsat` for the
four baselines and `sat` for the twelve Trojan variants.

### License

This code is distributed under the MIT License. See [LICENSE](LICENSE).