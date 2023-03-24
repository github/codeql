/**
 * @name Hard-coded data interpreted as code
 * @description Transforming hard-coded data (such as hexadecimal constants) into code
 *              to be executed is a technique often associated with backdoors and should
 *              be avoided.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision medium
 * @id rb/hardcoded-data-interpreted-as-code
 * @tags security
 *       external/cwe/cwe-506
 */

import codeql.ruby.security.HardcodedDataInterpretedAsCodeQuery
import codeql.ruby.DataFlow
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ is interpreted as " + sink.getNode().(Sink).getKind() + ".", source.getNode(),
  "Hard-coded data"
