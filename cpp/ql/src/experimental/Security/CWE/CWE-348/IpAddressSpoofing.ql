/**
 * @name IP address spoofing
 * @description A remote endpoint identifier is read from an HTTP header.
 *              Attackers can modify the value of the identifier to forge the client IP.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id cpp/ip-address-spoofing
 * @tags security
 *       external/cwe/cwe-348
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

/** A call that reads a forgeable IP address. */
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

/** A call to `strcmp()`. */
class StrcmpCall extends FunctionCall {
  StrcmpCall() { this.getTarget().getQualifiedName() = "strcmp" }
}

/**
 * A call that is used in string parsing.
 * 
 * Any of `strtok()`, `strtok_s()`, or `strsep()`.
 */
class StringParseCall extends FunctionCall {
  StringParseCall() { this.getTarget().getQualifiedName() in ["strtok", "strtok_s", "strsep"] }
}

/** A taint tracking configuration for string comparisons with a forgeable IP address. */
class ForgeableIpAddressCheck extends TaintTracking::Configuration {
  ForgeableIpAddressCheck() { this = "ForgeableIpAddressCheck" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof ForgeableIpAddressRead
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ComparisonOperation comparison | node.asExpr() = comparison.getAnOperand()) or
    exists(StrcmpCall strcmp | node.asExpr() = strcmp.getAnArgument())
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(StringParseCall parse | node.asExpr() = parse.getAnArgument())
  }
}

from ForgeableIpAddressCheck forgeableCheck, DataFlow::PathNode source, DataFlow::PathNode sink
where forgeableCheck.hasFlowPath(source, sink)
select sink, source, sink, "Potentially spoofed IP address from $@ used in this check.", source, "here"
