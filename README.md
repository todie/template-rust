<div align="center">

<!-- Replace with your project logo -->
<img src="https://raw.githubusercontent.com/rust-lang/rust-artwork/master/logo/rust-logo-128x128.png" alt="logo" width="96" />

# template-rust

**A batteries-included GitHub template for production-grade Rust projects.**

[![CI](https://github.com/todie/template-rust/actions/workflows/ci.yml/badge.svg)](https://github.com/todie/template-rust/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Rust](https://img.shields.io/badge/rust-stable-orange.svg)](https://www.rust-lang.org)
[![crates.io](https://img.shields.io/crates/v/template-rust.svg)](https://crates.io/crates/template-rust)
[![codecov](https://codecov.io/gh/todie/template-rust/branch/main/graph/badge.svg)](https://codecov.io/gh/todie/template-rust)

</div>

---

## todie Template Family

This is the **Rust** template. Part of the todie.io standardized project scaffolding.

| Template | Language | Repo |
|----------|----------|------|
| **template-rust** | Rust | *you are here* |
| template-python | Python 3.12+ | [todie/template-python](https://github.com/todie/template-python) |
| template-node | TypeScript/Node | [todie/template-node](https://github.com/todie/template-node) |
| template-terraform | Terraform/IaC | [todie/template-terraform](https://github.com/todie/template-terraform) |

All templates follow the [todie.io SOP](https://github.com/todie) — consistent CI/CD, linting, security scanning, release automation, and commit discipline across every project.

---

## Overview

`template-rust` is a GitHub template repository that gives you a fully-wired Rust project in
seconds. Clone it, rename things, and ship — everything else is already configured.

**What's included:**

- Pinned `stable` toolchain with `rustfmt`, `clippy`, and `llvm-tools-preview`
- Opinionated `rustfmt` and `clippy` (pedantic + nursery) configs
- `cargo-deny` for license compliance and advisory scanning
- Four-stage `Dockerfile` with `cargo-chef` caching and a distroless non-root runtime
- Full GitHub Actions CI pipeline (fmt → clippy → nextest → deny → audit → coverage → miri)
- `release-please` for automated semantic versioning and changelogs
- `pre-commit` hooks for local enforcement
- MIT licensed, ready to fork

---

## Quick Start

**Use this template:**

```
GitHub → "Use this template" → "Create a new repository"
```

**Or clone directly:**

```bash
git clone https://github.com/todie/template-rust my-project
cd my-project

# Update identity
sed -i 's/template-rust/my-project/g' Cargo.toml README.md

# Install toolchain & pre-commit hooks
rustup show                        # installs pinned toolchain from rust-toolchain.toml
pip install pre-commit && pre-commit install

# Build & run
cargo run
```

---

## Development

### Build

```bash
cargo build                  # debug
cargo build --release        # optimized (LTO=thin, stripped)
```

### Test

```bash
cargo nextest run                      # fast parallel test runner
cargo nextest run --all-features       # with all feature flags
```

### Lint & Format

```bash
cargo fmt                              # format in place
cargo fmt --check                      # CI mode — no writes

cargo clippy --all-targets --all-features -- \
  -D warnings \
  -W clippy::pedantic \
  -W clippy::nursery \
  -A clippy::module_name_repetitions
```

### Security Audit

```bash
cargo deny check             # licenses + advisories + duplicate bans
cargo audit                  # RustSec advisories only
```

### Coverage

```bash
cargo llvm-cov --all-features
cargo llvm-cov --all-features --lcov --output-path lcov.info
```

---

## Docker

The `Dockerfile` uses a four-stage `cargo-chef` build for fast layer caching, and a
[distroless](https://github.com/GoogleContainerTools/distroless) `cc-debian12` runtime image
running as a non-root user.

```bash
# Build
docker build -t template-rust .

# Run
docker run --rm template-rust
```

**Stages:**

| Stage | Base | Purpose |
|---|---|---|
| `planner` | `rust:1-slim-bookworm` | Generate `cargo-chef` recipe |
| `cacher` | `rust:1-slim-bookworm` | Pre-build dependencies |
| `builder` | `rust:1-slim-bookworm` | Compile application, strip binary |
| `runtime` | `distroless/cc-debian12:nonroot` | Minimal production image |

---

## CI/CD

### Continuous Integration

The CI pipeline (`.github/workflows/ci.yml`) runs on every push and pull request to `main`:

| Job | Toolchain | Description |
|---|---|---|
| `fmt` | stable | `cargo fmt --check` |
| `clippy` | stable + nightly | pedantic + nursery lints |
| `test` | stable | `cargo nextest run` |
| `deny` | stable | license + advisory + ban checks |
| `audit` | stable | RustSec advisory scan |
| `coverage` | stable | `cargo llvm-cov` → Codecov |
| `miri` | nightly | undefined behavior detection (non-blocking) |

### Releases

Releases are fully automated via [release-please](https://github.com/googleapis/release-please).

1. Write commits using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` → bumps minor version
   - `fix:` → bumps patch version
   - `feat!:` / `BREAKING CHANGE:` → bumps major version
2. `release-please` opens a versioned PR with a generated `CHANGELOG.md`
3. Merge the PR → GitHub Release created → publish job uploads the binary

---



## Related Templates

Looking for a different language? Check out the other todie templates:

| Template | Stack |
|----------|-------|
| [template-python](https://github.com/todie/template-python) | Python · uv · ruff · pyright · pytest |
| [template-node](https://github.com/todie/template-node) | Node.js · TypeScript · Vitest · Biome |
| [template-terraform](https://github.com/todie/template-terraform) | Terraform · TFLint · Checkov · OPA |

---

## License

Copyright © 2026 [todie.io](https://todie.io). Released under the [MIT License](LICENSE).
