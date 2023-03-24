This directory contains a Bazel to CMake generator intended mainly for IDE integration.

[`cmake.bzl`](./cmake.bzl) contains the Bazel side, with the `cmake_aspect` rule gathering the necessary information
from `cc_*` rules and `generate_cmake` translating that information into CMake commands. `generate_cmake` targets also
depend on all files that are either generated or fetched from external repositories, so that Bazel will fill in those
dependencies before letting CMake do the C/C++ compilation.

[`setup.cmake`](./setup.cmake) contains the generic CMake setup, setting up some Bazel related global variables and
providing an `include_generated` macro to be used in `CMakeLists.txt` to include a specific `generate_cmake` Bazel
target.

See Swift's [`CMakeLists.txt`](../../../swift/CMakeLists.txt) file for an example usage.
