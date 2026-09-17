# MPX Meltdown Invulnerability Checking — Supporting Code

Formal-verification benchmarks (SMT-LIB2) supporting:

> Y. Moshood, S. K. Srinivasan, N. Mathure, and A. Govindankutty,
> "Invulnerability Checking for Memory Protection Extensions Against Meltdown,"
> in *2026 IEEE International Symposium on Circuits and Systems (ISCAS)*,
> 2026, pp. 2021–2025. DOI: [10.1109/ISCAS66217.2026.11562423](https://doi.org/10.1109/ISCAS66217.2026.11562423)
>
> ⚠️ The DOI, page range, NSF grant number, cited z3 version, and benchmark
> CPU spec above were transcribed from the authors' copy of the PDF. Please
> cross-check them against the final IEEE Xplore record before publishing,
> in case the indexed metadata differs from the transcribed copy.

This work was supported by the U.S. National Science Foundation (NSF) under
CNS Grant No. 2117190 (as stated in the paper's acknowledgment footnote).

See [`CITATION.cff`](CITATION.cff) for machine-readable citation metadata —
**note: `CITATION.cff` still has unfilled placeholders, see "Remaining
placeholders" below.**

## Paper access

This repository does **not** include the publisher-formatted PDF. The
downloaded copy is watermarked "© 2026 IEEE" / "Authorized licensed use
limited to..." — redistributing that exact file is an IEEE copyright/Xplore
terms issue, independent of how this code is licensed. Readers should obtain
the paper via the DOI above (IEEE Xplore) or, if permitted under IEEE's
author self-archiving policy, an author preprint the authors post separately.

## What this verifies, and what a result does and does not mean

Intel's Memory Protection Extensions (MPX) were shown vulnerable to Meltdown
[Krishnakumar & Rebeiro, 2019]. A hardware mitigation (`sload`/`sstore`,
implemented in the Load-Store Queue) was proposed to close that gap — but a
buggy or Trojan-infected implementation of the mitigation can itself remain
vulnerable. Each benchmark in this repository is a self-contained SMT-LIB2
query that asserts the **negation** of an inductive invariant (the paper's
"MPX Invulnerability Invariant", Invariant 1) over an SMT model of one
microarchitecture configuration, and asks z3 to check satisfiability of that
negation:

- **`unsat`** — the negation is unsatisfiable, i.e. the invariant holds in
  every state z3 explored under this encoding. This is the paper's "P"
  (Pass) classification for that benchmark.
- **`sat`** (with a model) — z3 found a reachable state violating the
  invariant. This is the paper's "C" (Counterexample) classification.

**What this does *not* claim by itself:** the invariant is checked over an
abstracted model — pointer/object metadata access is represented with
uninterpreted functions (paper, Section IV), and the cache is modeled as a
4-entry associative structure standing in for the mitigation logic under
test. An `unsat` result certifies that *this specific encoded invariant*
holds over *this specific model*; it is not, by itself, a general proof that
a real silicon implementation is free of every possible security flaw, only
evidence supporting the paper's argument that the modeled invariant
formalizes the required security property. Read the paper's Section IV for
the full argument connecting the invariant to the mitigation's security
goal.

## Repository structure

```
benchmarks/
  lsq08/   secure.smt2, trojan_base.smt2, trojan_bound.smt2, trojan_illegal_access.smt2   # 8-entry  LSQ
  lsq16/   secure.smt2, trojan_base.smt2, trojan_bound.smt2, trojan_illegal_access.smt2   # 16-entry LSQ
  lsq32/   secure.smt2, trojan_base.smt2, trojan_bound.smt2, trojan_illegal_access.smt2   # 32-entry LSQ
  lsq64/   secure.smt2, trojan_base.smt2, trojan_bound.smt2, trojan_illegal_access.smt2   # 64-entry LSQ
scripts/
  run_verification.sh   # runs z3 over all 16 benchmarks, checks results against expected verdicts, logs everything
```

**This repository contains 16 benchmark files:** four LSQ sizes (8, 16, 32,
64 entries), each with one Secure baseline and three Trojan variants (Base,
Bound, Illegal Memory Access). These are the benchmarks this repository
provides.

## Software versions

Tested with:

- **z3 SMT solver 4.15.1** (`pip install z3-solver==4.15.1.0`; the pip
  package's version string appends a packaging suffix, but the solver
  itself reports `Z3 version 4.15.1` via `z3 --version`) — matching the
  version cited in the paper's Section VI.
- Python 3 (any recent 3.x; only used to install/provide the `z3` CLI via
  the `z3-solver` pip package).
- Bash + GNU coreutils `timeout` (for `scripts/run_verification.sh`'s
  per-benchmark timeout enforcement). Without `timeout` on `PATH` the
  script still runs but prints a warning and does not enforce timeouts.

The paper's own timings were measured on a 3.4 GHz Intel i7-2600, 4 GB RAM,
32-bit Linux (paper, Section VI) — a specific machine the authors used, not
a requirement for reproducing the *results*. Verification **verdicts**
(`sat`/`unsat`) are solver-version-dependent, not hardware-dependent.
Wall-clock **times** are hardware-dependent and are not expected to match
across machines — see "Expected output" below for the exact machine this
repository's numbers were measured on.

## Installation

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

This installs a self-contained z3 binary; no separate system package is
required.

## Running the verification

```bash
./scripts/run_verification.sh
```

This runs all 16 benchmarks through z3, one at a time, and for each one:
- enforces a timeout (120s default; 900s for `lsq64/trojan_illegal_access`,
  which is the slowest benchmark — override with the `DEFAULT_TIMEOUT_SEC`
  / `LONG_TIMEOUT_SEC` environment variables),
- compares the actual `sat`/`unsat` result against the expected verdict for
  that benchmark,
- saves full solver output to `results/logs/lsq<size>_<name>.log`,
- saves a machine-readable summary to `results/summary.csv`,
- saves solver version and hardware details to `results/machine_info.txt`.

A benchmark can fail to match for several distinct reasons, all reported
explicitly (never silently treated as success): `MISMATCH` (wrong
`sat`/`unsat` verdict), `MISSING_FILE`, `TIMEOUT`, or `SOLVER_ERROR`
(nonzero z3 exit with no valid verdict). **A timeout is never reported as a
passing result.** The script exits `0` only if all present benchmarks
matched their expected verdict, and exits `1` if anything failed, was
missing, timed out, or errored.

`results/` is local run output (git-ignored) — it is not part of the
repository's tracked content and is regenerated each time you run the
script.

To run a single benchmark directly and inspect z3's raw output (including,
for a Trojan benchmark, the counterexample model):

```bash
z3 benchmarks/lsq08/trojan_base.smt2
```

## Expected output

Re-running `scripts/run_verification.sh` while preparing this release
produced (z3 4.15.1, see exact machine details below):

```
LSQ      Benchmark                Expected   Result                Time(s)
---      ---------                --------   ------                -------
08       secure                   unsat      unsat                    0.22
08       trojan_base              sat        sat                      0.28
08       trojan_bound             sat        sat                      0.31
08       trojan_illegal_access    sat        sat                      0.23
16       secure                   unsat      unsat                    0.20
16       trojan_base              sat        sat                      0.77
16       trojan_bound             sat        sat                      1.03
16       trojan_illegal_access    sat        sat                      0.38
32       secure                   unsat      unsat                    0.23
32       trojan_base              sat        sat                      8.18
32       trojan_bound             sat        sat                      2.74
32       trojan_illegal_access    sat        sat                     16.10
64       secure                   unsat      unsat                    0.57
64       trojan_base              sat        sat                     21.83
64       trojan_bound             sat        sat                     16.79
64       trojan_illegal_access    sat        sat                    180.80

16 / 16 benchmarks matched their expected verdict.
RESULT: all present benchmarks matched their expected verdict.
```

Measured on: 12th Gen Intel Core i9-12900K (24 threads), 32 GB RAM, Linux
5.14.0-611.16.1.el9_7.x86_64, z3 4.15.1. **This is not the paper's machine**
(paper: 3.4 GHz Intel i7-2600, 4 GB RAM, 32-bit Linux) — only the
`sat`/`unsat` verdicts, not the absolute times, are claimed to match the
corresponding rows in the paper's Figures 3–4.

## Known limitations

1. Absolute verification times are hardware-dependent; only the
   `sat`/`unsat` verdicts are claimed to be reproducible across machines.
2. The invariant is checked over an abstracted model (uninterpreted
   functions for metadata access, a 4-entry cache standing in for the
   mitigation logic — paper, Section IV). See "What this verifies" above
   for what an `unsat`/`sat` result does and does not establish.

## Remaining placeholders — needed from you before publishing

`CITATION.cff` has two fields that still cannot be filled in without
information only you have (nothing has been invented in their place):
- `date-released` — the date you actually tag/release, not the date this
  archive was prepared.
- `identifiers[0].value` (Zenodo DOI) — only exists once Zenodo archives a
  GitHub release.

`repository-code` is now set to
[`https://github.com/mayuf413/mpx-meltdown-verification`](https://github.com/mayuf413/mpx-meltdown-verification).
The release has not been tagged and nothing has been archived on Zenodo yet.

## License

MIT — see [`LICENSE`](LICENSE). Copyright is attributed to all four paper
authors, per your instruction; you confirmed you hold the rights to
open-source this code.
