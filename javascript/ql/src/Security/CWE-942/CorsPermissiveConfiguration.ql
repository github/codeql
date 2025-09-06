/**
 * @name Permissive CORS configuration
 * @description Cross-origin resource sharing (CORS) policy allows overly broad access.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.0
 * @precision high
 * @id js/cors-permissive-configuration
 * @tags security
 *       external/cwe/cwe-942
 */

import javascript
import semmle.javascript.security.CorsPermissiveConfigurationQuery as CorsQuery
import CorsQuery::CorsPermissiveConfigurationFlow::PathGraph

from
  CorsQuery::CorsPermissiveConfigurationFlow::PathNode source,
  CorsQuery::CorsPermissiveConfigurationFlow::PathNode sink
where CorsQuery::CorsPermissiveConfigurationFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "CORS Origin allows broad access due to $@.", source.getNode(),
  "permissive or user controlled value"
