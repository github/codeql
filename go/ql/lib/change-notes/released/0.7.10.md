## 0.7.10

### Major Analysis Improvements

* We have significantly improved the Go autobuilder to understand a greater range of project layouts, which allows Go source files to be analysed that could previously not be processed.
* Go 1.22 has been included in the range of supported Go versions.

### Bug Fixes

* Fixed dataflow out of a `map` using a `range` statement.
