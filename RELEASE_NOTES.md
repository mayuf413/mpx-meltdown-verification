# Release Notes

## v1.0.0 — Initial public release (accompanies ISCAS 2026 paper)

Supporting SMT-LIB2 benchmarks for:

> Y. Moshood, S. K. Srinivasan, N. Mathure, and A. Govindankutty,
> "Invulnerability Checking for Memory Protection Extensions Against
> Meltdown," 2026 IEEE ISCAS, pp. 2021–2025, DOI:
> 10.1109/ISCAS66217.2026.11562423. (Please cross-check this metadata
> against the IEEE Xplore record before publishing.)

### Contents

- **16** SMT-LIB2 benchmarks encoding the MPX Invulnerability Invariant over
  4 Load-Store-Queue sizes (8/16/32/64 entries): a secure baseline plus the
  Base, Bound, and Illegal Memory Access MPX Trojans (paper Fig. 2), at
  every size — 4 sizes × 4 variants = 16 files.
- `scripts/run_verification.sh`: runs all 16 benchmarks through z3,
  compares each result to its expected verdict, enforces a per-benchmark
  timeout, and logs solver output/machine details/a CSV summary. Exits
  nonzero on any mismatch, missing file, timeout, or solver error.


### Verified

All 16 benchmarks were re-run against z3 4.15.1 (`z3-solver==4.15.1.0`,
matching the version cited in the paper) as part of preparing this release.
**16 of the 16 benchmarks matched their expected `sat`/`unsat` verdict.**

### License

MIT (see `LICENSE`). Copyright held jointly by the four paper authors.

### Not done in this release

- Not pushed to GitHub, not tagged, not archived on Zenodo.
- `CITATION.cff` still has placeholder fields (`date-released`, Zenodo DOI)
  pending those steps — see README "Remaining placeholders."
