---
category: minorAnalysis
---
* Overrides of `BroadcastReceiver::onReceive` with no statements in their body are no longer considered unverified by the `java/improper-intent-verification` query. This will reduce false positives from `onReceive` methods which do not perform any actions.
