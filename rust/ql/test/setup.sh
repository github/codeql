#!/bin/bash

set -euo pipefail

# This script is run by the CI to set up the test environment for the Rust QL tests
# We run this as rustup is not meant to be run in parallel, and will this setup will be run by rust-analyzer in the
# parallel QL tests unless we do the setup prior to launching the tests.
# We do this for each `rust-toolchain.toml` we use in the tests (and the root one in `rust`)

cd "$(dirname "$0")"

rustup install
rustup component add rust-src

find . -name rust-toolchain.toml \
  -execdir rustup install \; \
  -execdir rustup component add rust-src \;
