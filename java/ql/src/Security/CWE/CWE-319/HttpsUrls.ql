/**
 * @name Failure to use HTTPS URLs
 * @description Non-HTTPS connections can be intercepted by third parties.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @precision medium
 * @id java/non-https-url
 * @tags security
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.security.HttpsUrlsQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, MethodAccess m, HttpStringLiteral s
where
  source.getNode().asExpr() = s and
  sink.getNode().asExpr() = m.getQualifier() and
  any(HttpStringToUrlOpenMethodFlowConfig c).hasFlowPath(source, sink)
select m, source, sink, "URL may have been constructed with HTTP protocol, using $@.", s,
  "this source"
