/**
 * @name CORS misconfiguration for credentials transfer
 * @description Misconfiguration of CORS HTTP headers allows for leaks of secret credentials and CSRF attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/cors-misconfiguration-for-credentials
 * @tags security
 *       external/cwe/cwe-346
 *       external/cwe/cwe-639
 *       external/cwe/cwe-942
 */

import javascript
import semmle.javascript.security.dataflow.CorsMisconfigurationForCredentialsQuery
import CorsMisconfigurationFlow::PathGraph

from CorsMisconfigurationFlow::PathNode source, CorsMisconfigurationFlow::PathNode sink
where CorsMisconfigurationFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "CORS misconfiguration due to a $@.", source.getNode(),
  "permissive or user controlled value"
