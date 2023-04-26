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
import ClientSuppliedIpUsedInSecurityCheckLib
import ClientSuppliedIpUsedInSecurityCheckFlow::PathGraph

/**
 * Taint-tracking configuration tracing flow from obtaining a client ip from an HTTP header to a sensitive use.
 */
module ClientSuppliedIpUsedInSecurityCheckConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ClientSuppliedIpUsedInSecurityCheck
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof ClientSuppliedIpUsedInSecurityCheckSink }

  /**
   * Splitting a header value by `,` and taking an entry other than the first is sanitizing, because
   * later entries may originate from more-trustworthy intermediate proxies, not the original client.
   */
  predicate isBarrier(DataFlow::Node node) {
    exists(ArrayAccess aa, MethodAccess ma | aa.getArray() = ma |
      ma.getQualifier() = node.asExpr() and
      ma.getMethod() instanceof SplitMethod and
      not aa.getIndexExpr().(CompileTimeConstantExpr).getIntValue() = 0
    )
    or
    node.getType() instanceof PrimitiveType
    or
    node.getType() instanceof BoxedType
  }
}

module ClientSuppliedIpUsedInSecurityCheckFlow =
  TaintTracking::Global<ClientSuppliedIpUsedInSecurityCheckConfig>;

from
  ClientSuppliedIpUsedInSecurityCheckFlow::PathNode source,
  ClientSuppliedIpUsedInSecurityCheckFlow::PathNode sink
where ClientSuppliedIpUsedInSecurityCheckFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "IP address spoofing might include code from $@.",
  source.getNode(), "this user input"
