import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.controlflow.Guards
import BufferAccess
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

class NetworkFunctionCall extends FunctionCall {
  NetworkFunctionCall() {
    getTarget().hasName("ntohd") or
    getTarget().hasName("ntohf") or
    getTarget().hasName("ntohl") or
    getTarget().hasName("ntohll") or
    getTarget().hasName("ntohs")
  }
}

class NetworkToBufferSizeConfiguration extends DataFlow::Configuration {
  NetworkToBufferSizeConfiguration() { this = "NetworkToBufferSizeConfiguration" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof NetworkFunctionCall }

  override predicate isSink(DataFlow::Node node) {
    node.asExpr() = any(BufferAccess ba).getAccessedLength()
  }

  override predicate isBarrier(DataFlow::Node node) {
    exists(GuardCondition gc, GVN gvn |
      gc.getAChild*() = gvn.getAnExpr() and
      globalValueNumber(node.asExpr()) = gvn and
      gc.controls(node.asExpr().getBasicBlock(), _)
    )
  }
}
