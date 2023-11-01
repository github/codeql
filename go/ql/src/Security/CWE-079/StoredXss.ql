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
import semmle.go.security.StoredXss
import StoredXss::Flow::PathGraph

from StoredXss::Flow::PathNode source, StoredXss::Flow::PathNode sink
where StoredXss::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "Stored cross-site scripting vulnerability due to $@.",
  source.getNode(), "stored value"
