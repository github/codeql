## 1.3.1

### Minor Analysis Improvements

* The "Returning stack-allocated memory" query (`cpp/return-stack-allocated-memory`) no longer produces results if there is an extraction error in the returned expression.
* The "Badly bounded write" query (`cpp/badly-bounded-write`) no longer produces results if there is an extraction error in the type of the output buffer.
* The "Too few arguments to formatting function" query (`cpp/wrong-number-format-arguments`) no longer produces results if an argument has an extraction error.
* The "Wrong type of arguments to formatting function" query (`cpp/wrong-type-format-argument`) no longer produces results when an argument type has an extraction error.
* Added dataflow models and flow sources for Microsoft's Active Template Library (ATL).
