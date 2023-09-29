/**
 * @name overly CORS configuration
 * @description Misconfiguration of CORS HTTP headers allows CSRF attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/cors-misconfiguration
 * @tags security
 *       external/cwe/cwe-942
 */

import javascript
import semmle.javascript.security.dataflow.CorsPermissiveConfigurationQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ misconfiguration due to a $@.", sink.getNode(),
  "CORS Origin", source.getNode(), "too permissive or user controlled value"
