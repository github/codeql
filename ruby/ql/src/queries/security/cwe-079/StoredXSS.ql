/**
 * @name Stored cross-site scripting
 * @description Using uncontrolled stored values in HTML allows for
 *              a stored cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id rb/stored-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import ruby
import codeql.ruby.security.StoredXSSQuery
import codeql.ruby.DataFlow
import DataFlow::PathGraph

from StoredXss::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@",
  source.getNode(), "stored value"
