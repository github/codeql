# C/C++ CodeQL tests

This document provides additional information about the C/C++ CodeQL tests located in `cpp/ql/test`.  The principles under "Copying code", below, also apply to any other C/C++ code in this repository, such as examples linked from query `.qhelp` files in `cpp/ql/src`.  For more general information about contributing to this repository, see [Contributing to CodeQL](/CONTRIBUTING.md).

The tests can be run through Visual Studio Code.  Advanced users may also use the `codeql test run` command.

## Contributing to the tests

We are keen to have unit tests for all of our QL code.

Every query in `cpp/ql/src` (outside of `cpp/ql/src/experimental`) should have a test in the corresponding subdirectory of `cpp/ql/test/query-tests`. At a minimum, each query test should contain one case that should be detected by the query, and one related case that should not.

For example a simple test for the "Memory is never freed" (`cpp/memory-never-freed`) query might contain the following cases:
```
int *array1, *array2;

array1 = (int *)malloc(sizeof(int) * 100); // BAD: never freed

array2 = (int *)malloc(sizeof(int) * 100); // GOOD
free(array2);
```

Features of the QL libraries in `cpp/ql/src` should also have test coverage, in `cpp/ql/test/library-tests`.

## Copying code

The contents of `cpp/ql/test` should be original - nothing should be copied from other sources. In particular do not copy-paste C/C++ code from third-party projects, your own projects, or the standard C/C++ library implementation of your compiler (regardless of the associated license). As an exception, required declarations may be taken from the following sources where necessary:
 - [ISO/IEC Programming languages - C](https://www.iso.org/standard/74528.html) (all versions)
 - [ISO/IEC Programming languages - C++](https://www.iso.org/standard/68564.html) (all versions)
 - Code from existing queries and tests in this repository.
   This includes 'translating QL to C++', that is, writing C/C++ declarations from the information such as parameter names and positions specified in QL classes (when there is enough information to do so).
 - Code in the public domain

For example the test above for the "Memory is never freed" (`cpp/memory-never-freed`) query requires the following declarations, taken from [ISO/IEC 9899:2018 - Programming languages - C](https://www.iso.org/standard/74528.html):
```
void *malloc(size_t size);
void free(void *ptr);
```
We also need to write our own definition of `size_t`.  Any unsigned integral type will do for our purposes:
```
typedef unsigned int size_t;
```

## Including files

Standard and third-party library header files should not be included in tests by means of `#include` or similar mechanisms. This is because the tests should be independent of platform and library versions installed on the running machine. Standard library declarations may be inserted directly where necessary (see the rules in the section above), but it is generally better to avoid using the standard library at all when possible.

`#include` may be used to include files from the same directory within `cpp/ql/test`.  For example the test for "Include header files only" (`cpp/include-non-header`) includes other files in the test directory:
```
#include "test.H"
#include "test.xpm"
#include "test2.c"
```
