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

import codeql.ruby.AST
import codeql.ruby.security.StoredXSSQuery
import StoredXss::PathGraph

from StoredXss::PathNode source, StoredXss::PathNode sink
where StoredXss::flowPath(source, sink)
select sink.getNode(), source, sink, "Stored cross-site scripting vulnerability due to $@.",
  source.getNode(), "stored value"
