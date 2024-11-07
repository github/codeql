## 1.2.0

### New Features

* The syntax for models-as-data rows has been extended to make it easier to select sources, sinks, and summaries that involve templated functions and classes. Additionally, the syntax has also been extended to make it easier to specify models with arbitrary levels of indirection. See `dataflow/ExternalFlow.qll` for the updated documentation and specification for the model format.
* It is now possible to extend the classes `AllocationFunction` and `DeallocationFunction` via data extensions. Extensions of these classes should be added to the `lib/ext/allocation` and `lib/ext/deallocation` directories respectively.

### Minor Analysis Improvements

* The queries "Potential double free" (`cpp/double-free`) and "Potential use after free" (`cpp/use-after-free`) now produce fewer false positives.
* The "Guards" library (`semmle.code.cpp.controlflow.Guards`) now also infers guards from calls to the builtin operation `__builtin_expect`. As a result, some queries may produce fewer false positives.
