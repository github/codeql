## 1.3.3

### Minor Analysis Improvements

* The "Wrong type of arguments to formatting function" query (`cpp/wrong-type-format-argument`) now produces fewer FPs if the formatting function has multiple definitions.
* The "Call to memory access function may overflow buffer" query (`cpp/overflow-buffer`) now produces fewer FPs involving non-static member variables.
