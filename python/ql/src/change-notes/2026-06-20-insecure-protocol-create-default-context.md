---
category: minorAnalysis
---
* The `py/insecure-protocol` query no longer reports `ssl.create_default_context` as allowing TLS 1.0 or TLS 1.1. Since Python 3.10, the context returned by `ssl.create_default_context` has its `minimum_version` set to `TLSVersion.TLSv1_2` by default, so these protocol versions are not allowed and the previous alerts were false positives.
