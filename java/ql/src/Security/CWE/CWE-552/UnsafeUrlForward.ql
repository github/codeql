/**
 * @name Unsafe URL forward or include from a remote source
 * @description URL forward or include based on unvalidated user-input
 *              may cause file information disclosure.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-url-forward-include
 * @tags security
 *       external/cwe-552
 */

import java
import semmle.code.java.security.UnsafeUrlForwardQuery
import UnsafeUrlForwardFlow::PathGraph

from UnsafeUrlForwardFlow::PathNode source, UnsafeUrlForwardFlow::PathNode sink
where UnsafeUrlForwardFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL forward due to $@.",
  source.getNode(), "user-provided value"
