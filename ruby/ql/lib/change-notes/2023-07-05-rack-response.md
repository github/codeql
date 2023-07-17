---
category: minorAnalysis
---
* Query parameters and cookies from `Rack::Response` objects are recognized as potential sources of remote flow input.
* Calls to `Rack::Utils.parse_query` now propagate taint.
