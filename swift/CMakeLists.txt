# this uses generated cmake files to setup cmake compilation of the swift extractor
# this is provided solely for IDE integration

cmake_minimum_required(VERSION 3.21)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES x86_64) # temporary until we can build a Universal Binary
endif()

project(codeql)

include(../misc/bazel/cmake/setup.cmake)

generate_and_include(//swift/...)
