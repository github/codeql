/**
 * @name Use of externally-controlled format string
 * @description Using external input in format strings can lead to garbled output.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.3
 * @precision high
 * @id rb/tainted-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.security.TaintedFormatStringQuery
import TaintedFormatStringFlow::PathGraph

from TaintedFormatStringFlow::PathNode source, TaintedFormatStringFlow::PathNode sink
where TaintedFormatStringFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Format string depends on a $@.", source.getNode(),
  "user-provided value"
