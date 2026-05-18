---
category: minorAnalysis
---
* Added flow source models for `scanf_s` and related functions.
* Added a `Call` column to `LocalFlowSourceFunction::hasLocalFlowSource` and `RemoteFlowSourceFunction::hasRemoteFlowSource`. The old predicates without a `Call` column continue to be supported.