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
import CorsPermissiveConfigurationQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "CORS Origin misconfiguration due to a $@.", source.getNode(),
  "too permissive or user controlled value"
