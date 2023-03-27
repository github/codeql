import cpp
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.new.TaintTracking

module NetworkToBufferSizeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr().(FunctionCall).getTarget().hasGlobalName("ntohl")
  }

  predicate isSink(DataFlow::Node node) {
    exists(ArrayExpr ae | node.asExpr() = ae.getArrayOffset())
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Loop loop, LoopCounter lc |
      loop = lc.getALoop() and
      loop.getControllingExpr().(RelationalOperation).getGreaterOperand() = pred.asExpr()
    |
      succ.asExpr() = lc.getVariableAccessInLoop(loop)
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(GuardCondition gc, Variable v |
      gc.getAChild*() = v.getAnAccess() and
      node.asExpr() = v.getAnAccess() and
      gc.controls(node.asExpr().getBasicBlock(), _) and
      not exists(Loop loop | loop.getControllingExpr() = gc)
    )
  }
}

module NetworkToBufferSizeFlow = TaintTracking::Global<NetworkToBufferSizeConfig>;

from DataFlow::Node ntohl, DataFlow::Node offset
where NetworkToBufferSizeFlow::flow(ntohl, offset)
select offset, "This array offset may be influenced by $@.", ntohl,
  "converted data from the network"
