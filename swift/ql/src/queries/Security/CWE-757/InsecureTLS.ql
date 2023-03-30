/**
 * @name Insecure TLS configuration
 * @description TLS v1.0 and v1.1 versions are known to be vulnerable. TLS v1.2 or v1.3 should be used instead.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/insecure-tls
 * @tags security
 *       external/cwe/cwe-757
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import InsecureTlsFlow::PathGraph

/**
 * A taint config to detect insecure configuration of `NSURLSessionConfiguration`
 */
module InsecureTlsConfig implements DataFlow::ConfigSig {
  /**
   * Holds for enum values that represent an insecure version of TLS
   */
  predicate isSource(DataFlow::Node node) {
    node.asExpr().(MethodLookupExpr).getMember().(EnumElementDecl).getName() =
      ["TLSv10", "TLSv11", "tlsProtocol10", "tlsProtocol11"]
  }

  /**
   * Holds for assignment of TLS-related properties of `NSURLSessionConfiguration`
   */
  predicate isSink(DataFlow::Node node) {
    exists(AssignExpr assign |
      assign.getSource() = node.asExpr() and
      assign.getDest().(MemberRefExpr).getMember().(ConcreteVarDecl).getName() =
        [
          "tlsMinimumSupportedProtocolVersion", "tlsMinimumSupportedProtocol",
          "tlsMaximumSupportedProtocolVersion", "tlsMaximumSupportedProtocol"
        ]
    )
  }
}

module InsecureTlsFlow = TaintTracking::Global<InsecureTlsConfig>;

from InsecureTlsFlow::PathNode sourceNode, InsecureTlsFlow::PathNode sinkNode
where InsecureTlsFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This TLS configuration is insecure."
