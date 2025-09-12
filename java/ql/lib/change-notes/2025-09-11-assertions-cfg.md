---
category: minorAnalysis
---
* Improved support for various assertion libraries, in particular JUnit. This affects the control-flow graph slightly, and in turn affects several queries (mainly quality queries). Most queries should see improved precision (new true positives and fewer false positives), in particular `java/constant-comparison`, `java/index-out-of-bounds`, `java/dereferenced-value-may-be-null`, and `java/useless-null-check`. Some medium precision queries like `java/toctou-race-condition` and `java/unreleased-lock` may see mixed result changes (both slight improvements and slight regressions).
