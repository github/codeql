/**
 * @name Server-side request forgery
 * @description Making web requests based on unvalidated user-input
 *              may cause the server to communicate with malicious servers.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id java/ssrf-automodel
 * @tags security
 *       external/cwe/cwe-918
 *       ai-generated
 */

import java
import semmle.code.java.security.RequestForgeryConfig
import RequestForgeryFlow::PathGraph
private import semmle.code.java.AutomodelSinkTriageUtils

from RequestForgeryFlow::PathNode source, RequestForgeryFlow::PathNode sink
where RequestForgeryFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Potential server-side request forgery due to a $@." +
    getSinkModelQueryRepr(sink.getNode().asExpr()), source.getNode(), "user-provided value"
