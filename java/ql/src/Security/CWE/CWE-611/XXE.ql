/**
 * @name Resolving XML external entity in user-controlled data
 * @description Parsing user-controlled XML documents and allowing expansion of external entity
 * references may lead to disclosure of confidential data or denial of service.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id java/xxe
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-776
 *       external/cwe/cwe-827
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.XxeRemoteQuery
import XxeFlow::PathGraph

from XxeFlow::PathNode source, XxeFlow::PathNode sink
where XxeFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "XML parsing depends on a $@ without guarding against external entity expansion.",
  source.getNode(), "user-provided value"
