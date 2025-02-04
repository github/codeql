/**
 * @name Reflected server-side cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @sub-severity high
 * @precision high
 * @id rb/reflected-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import codeql.ruby.AST
import codeql.ruby.security.ReflectedXSSQuery
import ReflectedXssFlow

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to a $@.",
  source.getNode(), "user-provided value"
