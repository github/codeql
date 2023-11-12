/**
 * @id java/trust-boundary-violation
 * @name Trust boundary violation
 * @description Modifying the HTTP session attributes based on data from an untrusted source may violate a trust boundary.
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
