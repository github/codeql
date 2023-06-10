/**
 * @id java/trust-boundary-violation
 * @name Trust boundary violation
 * @description A user-provided value is used to set a session attribute.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision medium
 * @tags security
 *      external/cwe/cwe-501
 */

import java
import semmle.code.java.security.TrustBoundaryViolationQuery
import TrustBoundaryFlow::PathGraph

from TrustBoundaryFlow::PathNode source, TrustBoundaryFlow::PathNode sink
where TrustBoundaryFlow::flowPath(source, sink)
select sink.getNode(), sink, source,
  "This servlet reads data from a remote source and writes it to a session variable."
