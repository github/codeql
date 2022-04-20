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

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.security.TaintedFormatStringQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows here and is used in a format string.",
  source.getNode(), "User-provided value"
