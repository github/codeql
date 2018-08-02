/**
 * @name CORS misconfiguration for credentials transfer
 * @description Misconfiguration of CORS HTTP headers allows for leaks of secret credentials.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/cors-misconfiguration-for-credentials
 * @tags security
 *       external/cwe/cwe-346
 *       external/cwe/cwe-639
 */


import javascript
import semmle.javascript.security.dataflow.CorsMisconfigurationForCredentials::CorsMisconfigurationForCredentials

from Configuration cfg, DataFlow::Node source, Sink sink
where cfg.hasFlow(source, sink)
select sink, "$@ leak vulnerability due to $@.",
       sink.getCredentialsHeader(), "Credential",
       source, "a misconfigured CORS header value"
