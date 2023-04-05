/**
 * @name HTTP response splitting
 * @description Writing user input directly to an HTTP header
 *              makes code vulnerable to attack by header splitting.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/http-response-splitting
 * @tags security
 *       external/cwe/cwe-113
 */

import java
import semmle.code.java.security.ResponseSplittingQuery
import ResponseSplittingFlow::PathGraph

from ResponseSplittingFlow::PathNode source, ResponseSplittingFlow::PathNode sink
where ResponseSplittingFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This header depends on a $@, which may cause a response-splitting vulnerability.",
  source.getNode(), "user-provided value"
