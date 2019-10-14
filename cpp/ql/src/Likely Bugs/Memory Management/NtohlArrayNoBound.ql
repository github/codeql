/**
 * @description Using the result of a network-to-host byte order function, such as ntohl, as an array bound or length value without checking it may result in buffer overflows or other vulnerabiltiies
 * @id cpp/network-to-host-function-as-array-bound
 * @impact Remote Code Execution
 * @kind problem
 * @name Untrusted network-to-host usage
 * @problem.severity error
 * @query-version 1.0
 * @security.severity Critical
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.security.memory.BufferAccess
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

from DataFlow::Node source, DataFlow::Node sink, NetworkToBufferSizeConfiguration bufConfig
where bufConfig.hasFlow(source, sink)
select sink, "$@: Unchecked use of data from network function $@", source.getFunction(),
  source.getFunction().toString(), source, source.toString()
