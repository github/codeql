/**
 * @name Open URL redirect
 * @description Open URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity warning
 * @id go/unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import go
import semmle.go.security.OpenUrlRedirect::OpenUrlRedirect
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL redirection due to $@.", source.getNode(),
  "user-provided value"
