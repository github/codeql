/**
 * @name HTTP response splitting from local source
 * @description Writing user input directly to an HTTP header
 *              makes code vulnerable to attack by header splitting.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 6.1
 * @precision medium
 * @id java/http-response-splitting-local
 * @tags security
 *       external/cwe/cwe-113
 */

import java
import semmle.code.java.security.ResponseSplittingLocalQuery
import ResponseSplittingLocalFlow::PathGraph

from ResponseSplittingLocalFlow::PathNode source, ResponseSplittingLocalFlow::PathNode sink
where ResponseSplittingLocalFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This header depends on a $@, which may cause a response-splitting vulnerability.",
  source.getNode(), "user-provided value"
