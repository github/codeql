# this uses generated cmake files to setup cmake compilation of the swift extractor
# this is provided solely for IDE integration

cmake_minimum_required(VERSION 3.21)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

project(codeql)

include(../misc/bazel/cmake/setup.cmake)

include_generated(//swift/extractor:cmake)
include_generated(//swift/xcode-autobuilder:cmake)
