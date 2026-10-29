---
category: minorAnalysis
---
* Added neutral models to inhibit spurious generated sink models for `actix_web::HttpRequest::connection_info` and the methods built on it, such as `full_url` and `url_for`. This fixes some false positive results from queries such as `rust/uncontrolled-allocation-size` and `rust/log-injection`.
