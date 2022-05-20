# Improvements to Python analysis

* Importing `semmle.python.web.HttpRequest` will no longer import `UntrustedStringKind` transitively. `UntrustedStringKind` is the most commonly used non-abstract subclass of `ExternalStringKind`. If not imported (by one mean or another), taint-tracking queries that concern `ExternalStringKind` will not produce any results. Please ensure such queries contain an explicit import (`import semmle.python.security.strings.Untrusted`).
* Added model of taint sources for HTTP servers using `http.server`.
* Added taint modeling of routed parameters in Flask.
* Improved modeling of built-in methods on strings for taint tracking.
* Improved classification of test files.
* New class `BoundMethodValue` represents a bound method during runtime.
* The query `py/command-line-injection` now recognizes command execution with the `fabric` and `invoke` Python libraries.
