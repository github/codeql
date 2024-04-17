/**
 * @name IP address spoofing
 * @description A remote endpoint identifier is read from an HTTP header. Attackers can modify the value
 *              of the identifier to forge the client ip.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/ip-address-spoofing
 * @tags security
 *       experimental
 *       external/cwe/cwe-348
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import ClientSuppliedIpUsedInSecurityCheckLib
import ClientSuppliedIpUsedInSecurityCheckFlow::PathGraph

/**
 * A taint-tracking configuration tracing flow from obtaining a client ip from an HTTP header to a sensitive use.
 */
private module ClientSuppliedIpUsedInSecurityCheckConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ClientSuppliedIpUsedInSecurityCheck
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof PossibleSecurityCheck }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallCfgNode ccn |
      ccn = API::moduleImport("netaddr").getMember("IPAddress").getACall() and
      ccn.getArg(0) = pred and
      ccn = succ
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    // `client_supplied_ip.split(",")[n]` for `n` > 0
    exists(Subscript ss |
      not ss.getIndex().(IntegerLiteral).getText() = "0" and
      ss.getObject().(Call).getFunc().(Attribute).getName() = "split" and
      ss.getObject().(Call).getAnArg().(StringLiteral).getText() = "," and
      ss = node.asExpr()
    )
  }
}

/** Global taint-tracking for detecting "client ip used in security check" vulnerabilities. */
module ClientSuppliedIpUsedInSecurityCheckFlow =
  TaintTracking::Global<ClientSuppliedIpUsedInSecurityCheckConfig>;

from
  ClientSuppliedIpUsedInSecurityCheckFlow::PathNode source,
  ClientSuppliedIpUsedInSecurityCheckFlow::PathNode sink
where ClientSuppliedIpUsedInSecurityCheckFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "IP address spoofing might include code from $@.",
  source.getNode(), "this user input"
