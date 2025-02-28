---
category: minorAnalysis
---
* Due to changes in libraries the query "Static array access may cause overflow" (`cpp/static-buffer-overflow`) will no longer report cases where multiple fields of a struct or class are written with a single `memset` or similar operation.
