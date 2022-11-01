---
category: minorAnalysis
---

- Instantiations using `Faraday::Connection.new` are now recognized as part of `FaradayHttpRequest`s, meaning they will be considered as sinks for queries such as `rb/request-forgery`.
