/**
 * @name IP address spoofing
 * @description A remote endpoint identifier is read from an HTTP header. Attackers can modify the value
 *              of the identifier to forge the client ip.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/ip-address-spoofing
 * @tags security
 *       external/cwe/cwe-348
 */

import javascript
import semmle.javascript.dataflow.DataFlow
import semmle.javascript.dataflow.TaintTracking
import ClientSuppliedIpUsedInSecurityCheckLib

/**
 * Taint-tracking configuration tracing flow from obtaining a client ip from an HTTP header to a sensitive use.
 */
class ClientSuppliedIpUsedInSecurityCheckConfig extends TaintTracking::Configuration {
  ClientSuppliedIpUsedInSecurityCheckConfig() { this = "ClientSuppliedIpUsedInSecurityCheckConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof ClientSuppliedIp }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PossibleSecurityCheck }

  /**
   * Splitting a header value by `,` and taking an entry other than the first is sanitizing, because
   * later entries may originate from more-trustworthy intermediate proxies, not the original client.
   */
  override predicate isSanitizer(DataFlow::Node node) {
    // ip.split(",").pop(); or var temp = ip.split(","); ip = temp.pop();
    exists(DataFlow::MethodCallNode split, DataFlow::MethodCallNode pop |
      split = node and
      split.getMethodName() = "split" and
      pop.getMethodName() = "pop" and
      split.getACall() = pop
    )
    or
    // ip.split(",")[ip.split(",").length - 1]; or var temp = ip.split(","); ip = temp[temp.length - 1];
    exists(DataFlow::MethodCallNode split, DataFlow::PropRead read |
      split = node and
      split.getMethodName() = "split" and
      read = split.getAPropertyRead() and
      not read.getPropertyNameExpr().getIntValue() = 0
    )
  }
}

from
  ClientSuppliedIpUsedInSecurityCheckConfig config, DataFlow::PathNode source,
  DataFlow::PathNode sink
where none()
select sink.getNode(), source, sink, "IP address spoofing might include code from $@.",
  source.getNode(), "this user input"
