import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

predicate src0(Node n) {
  n.asExpr().(MethodCall).getMethod().hasName("src") or
  n.asExpr().(FieldAccess).getField().hasName("fsrc")
}

predicate sink0(Node n) {
  exists(MethodCall sink |
    sink.getMethod().hasName("sink") and
    sink.getAnArgument() = n.asExpr()
  )
  or
  exists(AssignExpr assign |
    assign.getDest().(FieldAccess).getField().hasName("fsink") and
    n.asExpr() = assign.getSource()
  )
}

module Conf1 implements ConfigSig {
  predicate isSource(Node n) { src0(n) }

  predicate isSink(Node n) { sink0(n) }
}

module Conf2 implements ConfigSig {
  predicate isSource(Node n) { src0(n) }

  predicate isSink(Node n) { sink0(n) }

  predicate isBarrierIn(Node n) { src0(n) }
}

module Conf3 implements ConfigSig {
  predicate isSource(Node n) { src0(n) }

  predicate isSink(Node n) { sink0(n) }

  predicate isBarrierOut(Node n) { sink0(n) }
}

module Conf4 implements ConfigSig {
  predicate isSource(Node n) { src0(n) }

  predicate isSink(Node n) { sink0(n) }

  predicate isBarrierIn(Node n) { src0(n) }

  predicate isBarrierOut(Node n) { sink0(n) }
}

module StateConf1 implements StateConfigSig {
  class FlowState = Unit;

  predicate isSource(Node n, FlowState state) { src0(n) and exists(state) }

  predicate isSink(Node n, FlowState state) { sink0(n) and exists(state) }
}

module StateConf2 implements StateConfigSig {
  class FlowState = Unit;

  predicate isSource(Node n, FlowState state) { src0(n) and exists(state) }

  predicate isSink(Node n, FlowState state) { sink0(n) and exists(state) }

  predicate isBarrierIn(Node n, FlowState state) { isSource(n, state) }
}

module StateConf3 implements StateConfigSig {
  class FlowState = Unit;

  predicate isSource(Node n, FlowState state) { src0(n) and exists(state) }

  predicate isSink(Node n, FlowState state) { sink0(n) and exists(state) }

  predicate isBarrierOut(Node n, FlowState state) { isSink(n, state) }
}

module StateConf4 implements StateConfigSig {
  class FlowState = Unit;

  predicate isSource(Node n, FlowState state) { src0(n) and exists(state) }

  predicate isSink(Node n, FlowState state) { sink0(n) and exists(state) }

  predicate isBarrierIn(Node n, FlowState state) { isSource(n, state) }

  predicate isBarrierOut(Node n, FlowState state) { isSink(n, state) }
}

predicate flow(Node src, Node sink, string s) {
  Global<Conf1>::flow(src, sink) and s = "nobarrier"
  or
  Global<Conf2>::flow(src, sink) and s = "srcbarrier"
  or
  Global<Conf3>::flow(src, sink) and s = "sinkbarrier"
  or
  Global<Conf4>::flow(src, sink) and s = "both"
}

predicate stateFlow(Node src, Node sink, string s) {
  GlobalWithState<StateConf1>::flow(src, sink) and s = "nobarrier"
  or
  GlobalWithState<StateConf2>::flow(src, sink) and s = "srcbarrier"
  or
  GlobalWithState<StateConf3>::flow(src, sink) and s = "sinkbarrier"
  or
  GlobalWithState<StateConf4>::flow(src, sink) and s = "both"
}

query predicate inconsistentFlow(Node src, Node sink, string message) {
  exists(string kind |
    (flow(src, sink, kind) and not stateFlow(src, sink, kind)) and
    message = "missing state-flow in configuration " + kind
    or
    (not flow(src, sink, kind) and stateFlow(src, sink, kind)) and
    message = "spurious state-flow in configuration " + kind
  )
}

from Node src, Node sink, string s
where flow(src, sink, _) and s = concat(any(string s0 | flow(src, sink, s0)), ", ")
select src, sink, s
