---
category: minorAnalysis
---
* The predicate `JaxWsEndpoint::getARemoteMethod` no longer requires the result to be annotated with `@WebMethod`. Instead, the requirements listed in the JAX-RPC Specification 1.1 for required parameter and return types are used. Applications using JAX-RS may see an increase in results.
