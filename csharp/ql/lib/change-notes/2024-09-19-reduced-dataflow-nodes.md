---
category: minorAnalysis
---
* `DataFlow::Node` instances are no longer created for library methods and fields that are not callable (either statically or dynamically) or otherwise referred to from source code. This may affect third-party queries that use these nodes to identify library methods or fields that are present in DLL files where those methods or fields are unreferenced. If this presents a problem, consider using `Callable` and other non-dataflow classes to identify such library entities.
