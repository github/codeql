---
category: minorAnalysis
---
* The `py/clear-text-logging-sensitive-data`, `py/clear-text-storage-sensitive-data`, and `py/weak-sensitive-data-hashing` queries no longer propagate sensitive data through resolved configuration lookups whose only value selectors are concrete, non-sensitive `section` and `key` arguments. Calls with sensitive or dynamic names, or with additional value arguments, remain unchanged.
