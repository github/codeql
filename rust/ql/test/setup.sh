#!/bin/bash

set -euo pipefail

# This script is run by the CI to set up the test environment for the Rust QL tests
# We run this as rustup is not meant to be run in parallel, and will this setup will be run by rust-analyzer in the
# parallel QL tests unless we do the setup prior to launching the tests.

# no need to install rust-src explicitly, it's listed in both toolchains
cd "$(dirname "$0")"
pushd ../../extractor/src/nightly-toolchain
rustup install
popd
# this needs to be last to set the default toolchain
rustup install
