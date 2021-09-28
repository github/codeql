/**
 * @name Hard-coded data interpreted as code
 * @description Transforming hard-coded data (such as hexadecimal constants) into code
 *              to be executed is a technique often associated with backdoors and should
 *              be avoided.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision medium
 * @id js/hardcoded-data-interpreted-as-code
 * @tags security
 *       external/cwe/cwe-506
 */

import javascript
import semmle.javascript.security.dataflow.HardcodedDataInterpretedAsCodeQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Hard-coded data from $@ is interpreted as " + sink.getNode().(Sink).getKind() + ".",
  source.getNode(), "here"
