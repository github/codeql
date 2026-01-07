/**
 * @name IP address spoofing
 * @description A remote endpoint identifier is read from an HTTP header. Attackers can modify the value
 *              of the identifier to forge the client ip.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/ip-address-spoofing
 * @tags security
 *       experimental
 *       external/cwe/cwe-348
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
deprecated import ClientSuppliedIpUsedInSecurityCheckLib
deprecated import ClientSuppliedIpUsedInSecurityCheckFlow::PathGraph

/**
 * Taint-tracking configuration tracing flow from obtaining a client ip from an HTTP header to a sensitive use.
 */
deprecated module ClientSuppliedIpUsedInSecurityCheckConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ClientSuppliedIpUsedInSecurityCheck
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof ClientSuppliedIpUsedInSecurityCheckSink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof ClientSuppliedIpUsedInSecurityCheckSanitizer
  }
}

deprecated module ClientSuppliedIpUsedInSecurityCheckFlow =
  TaintTracking::Global<ClientSuppliedIpUsedInSecurityCheckConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, ClientSuppliedIpUsedInSecurityCheckFlow::PathNode source,
  ClientSuppliedIpUsedInSecurityCheckFlow::PathNode sink, string message1,
  DataFlow::Node sourceNode, string message2
) {
  ClientSuppliedIpUsedInSecurityCheckFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "IP address spoofing might include code from $@." and
  sourceNode = source.getNode() and
  message2 = "this user input"
}
