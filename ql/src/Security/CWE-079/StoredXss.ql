/**
 * @name Stored cross-site scripting
 * @description Using uncontrolled stored values in HTML allows for
 *              a stored cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision low
 * @id go/stored-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import go
import semmle.go.security.StoredXss::StoredXss
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Stored cross-site scripting vulnerability due to $@.",
  source.getNode(), "stored value"
