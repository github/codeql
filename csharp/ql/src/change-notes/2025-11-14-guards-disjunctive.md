---
category: minorAnalysis
---
* An improvement to the Guards library for recognizing disjunctions means improved precision for `cs/constant-condition`, `cs/inefficient-containskey`, and `cs/dereferenced-value-may-be-null`. The two former can have additional findings, and the latter will have fewer false positives.
