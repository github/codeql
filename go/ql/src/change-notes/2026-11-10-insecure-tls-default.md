---
category: minorAnalysis
---
* The query `go/insecure-tls` ("Insecure TLS configuration") no longer flags a zero `tls.Config.MinVersion`, which selects Go's default minimum TLS version rather than an explicitly insecure version. Insecure `tls.Config.MaxVersion` values are also now reported even when `0` may also flow to `MaxVersion`.
