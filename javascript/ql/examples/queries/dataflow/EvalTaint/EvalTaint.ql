/**
 * @name Taint-tracking to 'eval' calls
 * @description Tracks user-controlled values into 'eval' calls (special case of js/code-injection).
 * @kind problem
 * @problem.severity error
 * @tags security
 * @id js/examples/eval-taint
 */

import javascript

module EvalTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    node = DataFlow::globalVarRef("eval").getACall().getArgument(0)
  }
}

module EvalTaintFlow = TaintTracking::Global<EvalTaintConfig>;

from DataFlow::Node source, DataFlow::Node sink
where EvalTaintFlow::flow(source, sink)
select sink, "Eval with user-controlled input from $@.", source, "here"
