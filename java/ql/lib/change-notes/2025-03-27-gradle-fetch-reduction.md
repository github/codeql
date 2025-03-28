---
category: fix
---
* In `build-mode: none` where the project has a Gradle build system, database creation no longer attempts to download some non-existent jar files relating to non-jar Maven artifacts, such as BOMs. This was harmless, but saves some time and reduces spurious warnings.
