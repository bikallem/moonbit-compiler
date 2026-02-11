FROM ocaml/opam:debian-12-ocaml-4.14 AS builder

# Install dune
RUN opam install dune --yes

WORKDIR /home/opam/moonbit-compiler

# Copy source
COPY --chown=opam:opam . .

# Remove stale dune.lock (OCaml + stdlib already provided by base image)
RUN rm -rf dune.lock

# Build moonc
RUN opam exec -- dune build --force

# Output stage - just the binary
FROM debian:12-slim
COPY --from=builder /home/opam/moonbit-compiler/_build/default/src/moon0_main.exe /usr/local/bin/moonc
