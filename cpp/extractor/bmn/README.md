# C/C++ build mode none extractor

This directory contains the C/C++ build mode none (BMN) extractor. It scans a
source tree and heuristically constructs extraction commands without observing
a build.

Run the Rust checks with:

```sh
./lint --check
cargo test
```

Build and test the Bazel target from the repository root with:

```sh
bazel build //cpp/extractor/bmn:bmn
bazel test //cpp/extractor/bmn:tests
```

After changing Cargo dependencies, regenerate the checked-in Bazel dependency
definitions with:

```sh
misc/bazel/3rdparty/update_cpp_bmn_deps.sh
```
