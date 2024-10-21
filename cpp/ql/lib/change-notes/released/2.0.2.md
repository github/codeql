## 2.0.2

### Minor Analysis Improvements

* Added taint flow model for `fopen` and related functions.
* The `SimpleRangeAnalysis` library (`semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis`) now generates more precise ranges for calls to `fgetc` and `getc`.
