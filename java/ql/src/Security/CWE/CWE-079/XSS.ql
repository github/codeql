/**
 * @name Cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/xss
 * @tags security
 *       external/cwe/cwe-079
 */

import java
import semmle.code.java.security.XssQuery
import XssFlow::PathGraph

class IsDiffInformed extends DataFlow::DiffInformedQuery {
  // This predicate is overridden to be more precise than the default
  // implementation in order to support secondary secondary data-flow
  // configurations that find sinks.
  override Location getASelectedSourceLocation(DataFlow::Node source) {
    XssConfig::isSource(source) and
    result = source.getLocation()
  }
}

from XssFlow::PathNode source, XssFlow::PathNode sink
where XssFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to a $@.",
  source.getNode(), "user-provided value"
