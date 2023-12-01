/**
 * @name URL forward from a remote source
 * @description URL forward based on unvalidated user-input
 *              may cause file information disclosure or
 *              redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/unvalidated-url-forward
 * @tags security
 *       external/cwe/cwe-552
 *       external/cwe/cwe-601
 */

import java
import semmle.code.java.security.UnsafeUrlForwardQuery
import UnsafeUrlForwardFlow::PathGraph

from UnsafeUrlForwardFlow::PathNode source, UnsafeUrlForwardFlow::PathNode sink
where UnsafeUrlForwardFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL forward depends on a $@.", source.getNode(),
  "user-provided value"
