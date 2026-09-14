---
category: minorAnalysis
---
* Fastify servers reached through a chainable configuration method, such as `fastify().withTypeProvider<T>()` or `fastify().setValidatorCompiler(...)`, are now recognized as the same server instance. Routes registered on such an instance are now attributed to their server, which may add results for queries such as `js/missing-rate-limiting` where routes were previously not recognized at all, and remove false positives where a globally registered plugin guards them.
