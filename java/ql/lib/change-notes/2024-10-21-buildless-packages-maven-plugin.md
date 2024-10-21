---
category: minorAnalysis
---
* Java `build-mode=none` extraction now packages the Maven plugin used to examine project dependencies. This means that dependency identification is more likely to succeed, and therefore analysis quality may rise, in scenarios where Maven Central is not reachable.
