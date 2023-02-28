import cpp
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.new.TaintTracking

class NetworkToBufferSizeConfiguration extends TaintTracking::Configuration {
  NetworkToBufferSizeConfiguration() { this = "NetworkToBufferSizeConfiguration" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr().(FunctionCall).getTarget().hasGlobalName("ntohl")
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ArrayExpr ae | node.asExpr() = ae.getArrayOffset())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Loop loop, LoopCounter lc |
      loop = lc.getALoop() and
      loop.getControllingExpr().(RelationalOperation).getGreaterOperand() = pred.asExpr()
    |
      succ.asExpr() = lc.getVariableAccessInLoop(loop)
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(GuardCondition gc, Variable v |
      gc.getAChild*() = v.getAnAccess() and
      node.asExpr() = v.getAnAccess() and
      gc.controls(node.asExpr().getBasicBlock(), _) and
      not exists(Loop loop | loop.getControllingExpr() = gc)
    )
  }
}

from DataFlow::Node ntohl, DataFlow::Node offset, NetworkToBufferSizeConfiguration conf
where conf.hasFlow(ntohl, offset)
select offset, "This array offset may be influenced by $@.", ntohl,
  "converted data from the network"
