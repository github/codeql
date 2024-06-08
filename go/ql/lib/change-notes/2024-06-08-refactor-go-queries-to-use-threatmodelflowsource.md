---
category: minorAnalysis
---
* The `Customizations` libraries for several queries, as well as queries which do not have `Customizations` libraries, have been modified to use `ThreatModelFlowSource` to define their `isSource` predicates instead of `RemoteFlowSource`. This means these queries will now respect threat model configurations.
