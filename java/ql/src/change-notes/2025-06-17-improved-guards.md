---
category: minorAnalysis
---
* Java analysis of guards has been switched to use the new and improved shared guards library. This improves precision of a number of queries, in particular `java/dereferenced-value-may-be-null`, which now has fewer false positives, and `java/useless-null-check` and `java/constant-comparison`, which gain additional true positives.
