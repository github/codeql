---
category: minorAnalysis
---
* URI template variables of all Spring `RestTemplate` methods are now considered as request forgery sinks. Previously only the `getForObject` method was considered. This may lead to more alerts for the query `java/ssrf`.
