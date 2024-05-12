/**
 * @name URL forward from a remote source
 * @description URL forward based on unvalidated user input
 *              may cause file information disclosure.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/unvalidated-url-forward
 * @tags security
 *       external/cwe/cwe-552
 */

import java
import semmle.code.java.security.UrlForwardQuery
import UrlForwardFlow::PathGraph

from UrlForwardFlow::PathNode source, UrlForwardFlow::PathNode sink
where UrlForwardFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL forward depends on a $@.", source.getNode(),
  "user-provided value"
