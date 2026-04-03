# CLAUDE.md — Rust Project (from todie/template-rust)

## Template Family
This project was scaffolded from [todie/template-rust](https://github.com/todie/template-rust).
See also: [template-python](https://github.com/todie/template-python) | [template-node](https://github.com/todie/template-node) | [template-terraform](https://github.com/todie/template-terraform)

## Build & Run
- `cargo build` — debug build
- `cargo build --release` — release build (LTO enabled)
- `cargo run` — run the binary

## Test
- `cargo nextest run` — run tests (preferred over `cargo test`)
- `cargo nextest run -p <crate>` — test a specific crate
- `cargo nextest run <test_name>` — run a single test
- `cargo llvm-cov --lcov` — generate coverage report

## Lint & Format
- `cargo fmt --check` — check formatting
- `cargo fmt` — auto-format
- `cargo clippy -- -D warnings -W clippy::pedantic -W clippy::nursery` — full lint pass
- Pre-commit hooks: `pre-commit run --all-files`

## Security & Supply Chain
- `cargo deny check` — license, advisory, ban checks (see deny.toml)
- `cargo audit` — RUSTSEC advisory database scan
- `cargo vet` — supply chain trust (when configured)

## CI Pipeline
CI runs on every PR: fmt → clippy → nextest → deny → audit → coverage upload.
Matrix: stable + nightly + MSRV. Miri runs on nightly for unsafe validation.

## Release
Uses release-please for automated semver. Write conventional commits:
- `feat:` → minor bump
- `fix:` → patch bump
- `feat!:` or `BREAKING CHANGE:` → major bump
- `chore:`, `docs:`, `refactor:`, `test:`, `ci:` → no version bump

## Commit Discipline
- One logical change per commit
- One commit stack per feature branch
- File a PR for each feature branch
- Never bundle unrelated changes
- Never push directly to main

## Architecture Notes
- Release profile: LTO=thin, codegen-units=1, strip=true
- Clippy: pedantic + nursery lints enabled (see clippy.toml for allowed exceptions)
- deny.toml: license allow-list (MIT, Apache-2.0, BSD-2/3, ISC, Unicode-DFS-2016, Zlib)
- Docker: multi-stage with cargo-chef for dependency caching
