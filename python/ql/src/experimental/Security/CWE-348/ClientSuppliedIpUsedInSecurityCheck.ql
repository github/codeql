/**
 * @name IP address spoofing
 * @description A remote endpoint identifier is read from an HTTP header. Attackers can modify the value
 *              of the identifier to forge the client ip.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/ip-address-spoofing
 * @tags security
 *       external/cwe/cwe-348
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import ClientSuppliedIpUsedInSecurityCheckLib
import DataFlow::PathGraph

/**
 * A taint-tracking configuration tracing flow from obtaining a client ip from an HTTP header to a sensitive use.
 */
class ClientSuppliedIpUsedInSecurityCheckConfig extends TaintTracking::Configuration {
  ClientSuppliedIpUsedInSecurityCheckConfig() { this = "ClientSuppliedIpUsedInSecurityCheckConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof ClientSuppliedIpUsedInSecurityCheck
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PossibleSecurityCheck }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallCfgNode ccn |
      ccn = API::moduleImport("netaddr").getMember("IPAddress").getACall() and
      ccn.getArg(0) = pred and
      ccn = succ
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    // `client_supplied_ip.split(",")[n]` for `n` > 0
    exists(Subscript ss |
      not ss.getIndex().(IntegerLiteral).getText() = "0" and
      ss.getObject().(Call).getFunc().(Attribute).getName() = "split" and
      ss.getObject().(Call).getAnArg().(StrConst).getText() = "," and
      ss = node.asExpr()
    )
  }
}

from
  ClientSuppliedIpUsedInSecurityCheckConfig config, DataFlow::PathNode source,
  DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "IP address spoofing might include code from $@.",
  source.getNode(), "this user input"
