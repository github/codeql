---
category: minorAnalysis
---
* Added a data flow model for `swap` member functions, which were previously modeled as taint tracking functions. This change improves the precision of queries where flow through `swap` member functions might affect the results.
