/**
 * @name Taint-tracking to 'eval' calls (with path visualization)
 * @description Tracks user-controlled values into 'eval' calls (special case of js/code-injection),
 *              and generates a visualizable path from the source to the sink.
 * @kind path-problem
 * @tags security
 * @id js/examples/eval-taint-path
 */

import javascript
import DataFlow
import DataFlow::PathGraph

class EvalTaint extends TaintTracking::Configuration {
  EvalTaint() { this = "EvalTaint" }

  override predicate isSource(Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(Node node) { node = globalVarRef("eval").getACall().getArgument(0) }
}

from EvalTaint cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Eval with user-controlled input from $@.", source.getNode(),
  "here"
