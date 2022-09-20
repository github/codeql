---
category: majorAnalysis
---
* The virtual dispatch relation used in data flow now favors summary models over source code for dispatch to interface methods from `java.util` unless there is evidence that a specific source implementation is reachable. This should provide increased precision for any projects that include, for example, custom `List` or `Map` implementations.
