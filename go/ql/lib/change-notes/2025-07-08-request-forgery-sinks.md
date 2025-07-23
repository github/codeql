---
category: minorAnalysis
---
* Added models for the `Head` function and the `Client.Head` method, from the `net/http` package, to the `Http::ClientRequest` class. This means that they will be recognized as sinks for the query `go/request-forgery` and the experimental query `go/ssrf`.
