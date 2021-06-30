import cpp
import semmle.code.cpp.dataflow.TaintTracking

class ForgeableIpAddressRead extends FunctionCall {
  ForgeableIpAddressRead() {
    this.getTarget().getQualifiedName() = "getenv" and
    this.getArgument(0).(StringLiteral).getValue() in [
        "HTTP_CLIENT_IP", "HTTP_FORWARDED", "HTTP_FORWARDED_FOR", "HTTP_PROXY_CLIENT_IP",
        "HTTP_VIA", "HTTP_WL_PROXY_CLIENT_IP", "HTTP_X_CLUSTER_CLIENT_IP", "HTTP_X_FORWARDED",
        "HTTP_X_FORWARDED_FOR", "HTTP_X_REAL_IP", "REMOTE_ADDR"
      ]
  }
}

class StrcmpCall extends FunctionCall {
  StrcmpCall() { this.getTarget().getQualifiedName() = "strcmp" }
}

class ForgeableIpAddressCheck extends TaintTracking::Configuration {
  ForgeableIpAddressCheck() { this = "ForgeableIpAddressCheck" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof ForgeableIpAddressRead
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ComparisonOperation comparison | node.asExpr() = comparison.getAnOperand()) or
    exists(StrcmpCall strcmp | node.asExpr() = strcmp.getAnArgument())
  }
}

from ForgeableIpAddressCheck forgeableCheck, DataFlow::Node source, DataFlow::Node sink
where forgeableCheck.hasFlow(source, sink)
select source, sink
