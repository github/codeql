/**
 * @name Log entries created from user input
 * @description Building log entries from user-controlled sources is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id go/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

import go
import semmle.go.security.LogInjection
import DataFlow::PathGraph

from LogInjection::Configuration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink, source, sink, "This log write receives unsanitized user input from $@.",
  source.getNode(), "here"
