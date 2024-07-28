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
import StoredXssFlow::PathGraph

from StoredXssFlow::PathNode source, StoredXssFlow::PathNode sink
where StoredXssFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Stored cross-site scripting vulnerability due to $@.",
  source.getNode(), "stored value"
