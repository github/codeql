---
 category: minorAnalysis
---
* The clear-text storage (`rb/clear-text-storage-sensitive-data`) and logging (`rb/clear-text-logging-sensitive-data`) queries now use built-in flow through hashes, for improved precision. This may result in both new true positives and less false positives.