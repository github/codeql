# Improvements to Python analysis

The following changes in version 1.24 affect Python analysis in all applications.

## General improvements

- Support for Django version 2.x and 3.x

- Taint tracking now correctly tracks taint in destructuring assignments. For example, if `tainted_list` is a list of tainted tainted elements, then
    ```python
    head, *tail = tainted_list
    ```
    will result in `tail` being tainted with the same taint as `tainted_list`, and `head` being tainted with the taint of the elements of `tainted_list`.

- A large number of libraries and queries have been moved to the new `Value` API, which should result in more precise results.

- The `Value` interface has been extended in various ways:
   - A new `StringValue` class has been added, for tracking string literals.
   - Values now have a `booleanValue` method which returns the boolean interpretation of the given value.
   - Built-in methods for which the return type is not fixed are now modeled as returning an unknown value by default.


## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Arbitrary file write during tarfile extraction (`py/tarslip`) | Fewer false negative results | Negations are now handled correctly in conditional expressions that may sanitize tainted values. |
| First parameter of a method is not named 'self' (`py/not-named-self`) | Fewer false positive results | `__class_getitem__` is now recognized as a class method. |
| Import of deprecated module (`py/import-deprecated-module`) | Fewer false positive results | Deprecated modules that are used to provide backwards compatibility are no longer reported.|
| Module imports itself (`py/import-own-module`) | Fewer false positive results | Imports local to a given package are no longer classified as self-imports. |
| Uncontrolled command line (`py/command-line-injection`) | More results | We now model the `fabric` and `invoke` packages for command execution. |

### Web framework support

The CodeQL library has improved support for the web frameworks: Bottle, CherryPy, Falcon, Pyramid, TurboGears, Tornado, and Twisted. They now provide a proper `HttpRequestTaintSource`, instead of a `TaintSource`. This will enable results for the following queries:

- `py/path-injection`
- `py/command-line-injection`
- `py/reflective-xss`
- `py/sql-injection`
- `py/code-injection`
- `py/unsafe-deserialization`
- `py/url-redirection`

The library also has improved support for the web framework Twisted. It now provides a proper
`HttpResponseTaintSink`, instead of a `TaintSink`. This will enable results for the following
queries:

- `py/reflective-xss`
- `py/stack-trace-exposure`

## Changes to libraries
### Taint tracking
- The `urlsplit` and `urlparse` functions now propagate taint appropriately.
- HTTP requests using the `requests` library are now modeled.
