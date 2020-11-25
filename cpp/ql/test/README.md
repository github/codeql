# C/C++ CodeQL tests

This document provides additional information about the C/C++ CodeQL Tests located in `cpp/ql/test`.  See [Contributing to CodeQL](CONTRIBUTING.md) for general information about contributing to this repository.

The tests can be run through Visual Studio Code.  Advanced users may also use the `codeql test run` command.

## Contributing to the tests

We are keen to have unit tests for all of our QL code.

Every query in `cpp/ql/src` (outside of `cpp/ql/src/experimental`) should have a test in the corresponding subdirectory of `cpp/ql/test/query-tests`. At a minimum, each query test shall contain one case that should be detected by the query, and one related case that should not.

TODO: example?

Library features should also have test coverage, in `cpp/ql/test/library-tests`.

## Copying code

The contents of `cpp/ql/test` should be original - nothing should be copied from other sources. In particular do not copy-paste C/C++ code from third party projects, your own projects, or the standard C/C++ library implementation of your compiler (regardless of the associated license). As an exception, required declarations may be taken from the following sources where necessary:
 - ISO/IEC Programming languages - C (all versions)
 - ISO/IEC Programming languages - C++ (all versions)

TODO: example

In addition, C/C++ and QL code may be copied from other queries and tests in this repository.

## Including files

Standard and third party library header files should not be included in tests by means of `#include` or similar mechanisms. This is because the tests should be independent of platform and library versions installed on the running machine. Standard library declarations may be inserted directly where necessary (see the rules in the section above), but it is generally better to avoid using the standard library at all when possible.

`#include` may be used to include files from the same directory within `cpp/ql/test`.

TODO: example
