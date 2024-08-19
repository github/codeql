---
category: fix
---
* Fixed an issue where analysis in `build-mode: none` may very occasionally throw a `CoderMalfunctionError` while resolving dependencies provided by a build system (Maven or Gradle), which could cause some dependency resolution and consequently alerts to vary unpredictably from one run to another.
