---
category: minorAnalysis
---
* The sensitive data heuristics used to identify code that handles passwords and private data have been improved. Most of the changes permit more variations of established patterns, thereby finding more sensitive data. Queries that use the sensitive data library (for example `js/clear-text-logging`) may find more correct results and fewer false positive results after these changes.
