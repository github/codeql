/**
 * @name Use of externally-controlled format string
 * @description Using external input in format strings can lead to garbled output.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/tainted-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import javascript
import semmle.javascript.security.dataflow.TaintedFormatString::TaintedFormatString
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasPathFlow(source, sink)
select sink.getNode(), "$@ flows here and is used in a format string.", source, "User-provided value"
