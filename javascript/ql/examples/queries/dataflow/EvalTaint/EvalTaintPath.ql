/**
 * @name Taint-tracking to 'eval' calls (with path visualization)
 * @description Tracks user-controlled values into 'eval' calls (special case of js/code-injection),
 *              and generates a visualizable path from the source to the sink.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 * @id js/examples/eval-taint-path
 */

import javascript

module EvalTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    node = DataFlow::globalVarRef("eval").getACall().getArgument(0)
  }
}

module EvalTaintFlow = TaintTracking::Global<EvalTaintConfig>;

import EvalTaintFlow::PathGraph

from EvalTaintFlow::PathNode source, EvalTaintFlow::PathNode sink
where EvalTaintFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Eval with user-controlled input from $@.", source.getNode(),
  "here"
