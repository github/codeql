---
category: minorAnalysis
---
* The `py/clear-text-logging-sensitive-data` and `py/clear-text-storage-sensitive-data` queries have been updated to exclude the `certificate` classification of of sensitive sources, which often do not actually contain sensitive data.