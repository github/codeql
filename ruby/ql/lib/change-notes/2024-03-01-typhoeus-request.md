---
category: minorAnalysis
---
* Calls to `Typhoeus::Request.new` are now considered as instances of the `Http::Client::Request` concept, with the response body being treated as a remote flow source.