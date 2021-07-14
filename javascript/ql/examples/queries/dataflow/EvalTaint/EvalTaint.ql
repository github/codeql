/**
 * @name Taint-tracking to 'eval' calls
 * @description Tracks user-controlled values into 'eval' calls (special case of js/code-injection).
 * @kind problem
 * @problem.severity error
 * @tags security
 * @id js/examples/eval-taint
 */

import javascript
import DataFlow

class EvalTaint extends TaintTracking::Configuration {
  EvalTaint() { this = "EvalTaint" }

  override predicate isSource(Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(Node node) { node = globalVarRef("eval").getACall().getArgument(0) }
}

from EvalTaint cfg, Node source, Node sink
where cfg.hasFlow(source, sink)
select sink, "Eval with user-controlled input from $@.", source, "here"
