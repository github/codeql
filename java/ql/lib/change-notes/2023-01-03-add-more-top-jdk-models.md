---
category: minorAnalysis
---
* Added more dataflow models for frequently-used JDK APIs.
* Removed summary model for `java.lang.String#endsWith(String)` and added neutral model for this API.
* Added additional taint step for `java.lang.String#endsWith(String)` to `ConditionalBypassFlowConfig`.
