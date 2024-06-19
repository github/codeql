---
category: minorAnalysis
---
* DataFlow queries which previously used `RemoteFlowSource` to define their sources have been modified to instead use `ThreatModelFlowSource`. This means these queries will now respect threat model configurations. The default threat model configuration is equivalent to `RemoteFlowSource`, so there should be no change in results for users using the default.
