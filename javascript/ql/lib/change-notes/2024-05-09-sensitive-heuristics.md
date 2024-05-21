---
category: minorAnalysis
---
* Additional heuristics for a new sensitive data classification for private information (e.g. credit card numbers) have been added to the shared `SensitiveDataHeuristics.qll` library. This may result in additional results for queries that use sensitive data such as `js/clear-text-storage-sensitive-data` and `js/clear-text-logging`.