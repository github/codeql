---
category: minorAnalysis
---
* Dataflow analysis has a new flow step through constructors of transitive subtypes of `java.io.InputStream` that wrap an underlying data source. Previously, the step only existed for direct subtypes of `java.io.InputStream`.
