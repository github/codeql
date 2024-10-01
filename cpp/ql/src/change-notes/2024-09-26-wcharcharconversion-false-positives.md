---
category: minorAnalysis
---
* The `cpp/incorrect-string-type-conversion` query now produces fewer false positives caused by failure to detect byte arrays.
* The `cpp/incorrect-string-type-conversion` query now produces fewer false positives caused by failure to recognize dynamic checks prior to possible dangerous widening.