---
category: fix
---
* Fixed an issue where analysis in `build-mode: none` may fail to resolve dependencies of Gradle projects where the dependency uses a non-empty artifact classifier -- for example, `someproject-1.2.3-tests.jar`, which has the classifier `tests`.
