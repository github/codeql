/**
 * @name Server-side URL redirect
 * @description Server-side URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @id js/server-side-unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import javascript
import semmle.javascript.security.dataflow.ServerSideUrlRedirectQuery
import ServerSideUrlRedirectFlow::PathGraph

from ServerSideUrlRedirectFlow::PathNode source, ServerSideUrlRedirectFlow::PathNode sink
where ServerSideUrlRedirectFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL redirection depends on a $@.", source.getNode(),
  "user-provided value"
