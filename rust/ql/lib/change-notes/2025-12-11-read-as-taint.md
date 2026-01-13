---
category: minorAnalysis
---
* Reading content of a value now carries taint if the value itself is tainted. For instance, if `s` is tainted then `s.field` is also tainted. This generally improves taint flow.