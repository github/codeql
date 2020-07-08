/**
 * @kind path-problem
 */

import go
import DataFlow::PathGraph

class Source extends DataFlow::ExprNode {
  Source() {
    exists(Function fn | fn.hasQualifiedName(_, "newSource") | this = fn.getACall().getResult())
  }
}

class Sink extends DataFlow::ExprNode {
  Sink() {
    exists(Function fn | fn.hasQualifiedName(_, "sink") | this = fn.getACall().getArgument(0))
  }
}

class Link extends TaintTracking::FunctionModel {
  Link() { hasQualifiedName(_, "link") }

  override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isParameter(0) and outp.isParameter(1)
  }
}

class FlowConf extends TaintTracking::Configuration {
  FlowConf() { this = "FlowConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
}

from FlowConf cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Flow from $@.", source.getNode(), "source"
