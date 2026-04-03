# syntax=docker/dockerfile:1

# ── Stage 1: planner ──────────────────────────────────────────────────────────
FROM rust:1-slim-bookworm AS planner
WORKDIR /app
RUN cargo install cargo-chef --locked
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

# ── Stage 2: cacher ───────────────────────────────────────────────────────────
FROM rust:1-slim-bookworm AS cacher
WORKDIR /app
RUN cargo install cargo-chef --locked
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

# ── Stage 3: builder ──────────────────────────────────────────────────────────
FROM rust:1-slim-bookworm AS builder
WORKDIR /app
COPY . .
COPY --from=cacher /app/target target
COPY --from=cacher /usr/local/cargo /usr/local/cargo
RUN cargo build --release --locked &&     strip target/release/template-rust

# ── Stage 4: runtime ──────────────────────────────────────────────────────────
FROM gcr.io/distroless/cc-debian12:nonroot AS runtime

LABEL org.opencontainers.image.title="template-rust"
LABEL org.opencontainers.image.description="A template Rust service"
LABEL org.opencontainers.image.source="https://github.com/todie/template-rust"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app
COPY --from=builder /app/target/release/template-rust /app/template-rust

USER nonroot:nonroot

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3     CMD ["/app/template-rust", "--health-check"] || exit 1

ENTRYPOINT ["/app/template-rust"]
