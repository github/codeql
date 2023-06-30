/**
 * @name URL redirection from remote source
 * @description URL redirection based on unvalidated user-input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/unvalidated-url-redirection-automodel
 * @tags security
 *       external/cwe/cwe-601
 *       ai-generated
 */

import java
import semmle.code.java.security.UrlRedirectQuery
import UrlRedirectFlow::PathGraph
private import semmle.code.java.AutomodelSinkTriageUtils

from UrlRedirectFlow::PathNode source, UrlRedirectFlow::PathNode sink
where UrlRedirectFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Untrusted URL redirection depends on a $@." + getSinkModelQueryRepr(sink.getNode().asExpr()),
  source.getNode(), "user-provided value"
