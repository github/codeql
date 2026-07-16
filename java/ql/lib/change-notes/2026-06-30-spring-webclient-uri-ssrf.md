---
category: minorAnalysis
---
* The first argument of the `uri` method of `WebClient$UriSpec` in `org.springframework.web.reactive.function.client` is now considered a request forgery sink. Previously only the first arguments of the `WebClient.create` and `WebClient$Builder.baseUrl` methods were considered. This may lead to more alerts for the query `java/ssrf` (Server-side request forgery).
