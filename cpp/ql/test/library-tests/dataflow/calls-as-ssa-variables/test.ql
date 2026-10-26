/**
 * @kind path-problem
 */

import semmle.code.cpp.ir.IR
import semmle.code.cpp.dataflow.new.DataFlow
import Flow::PathGraph

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asInstruction().(VariableAddressInstruction).getIRVariable() instanceof IRTempVariable
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asInstruction().(CallInstruction).getStaticCallTarget().hasName("get")
  }
}

module Flow = DataFlow::Global<Config>;

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode(), source, sink, ""
