/**
 * @name Insecure TLS configuration
 * @description TLS v1.0 and v1.1 versions are known to be vulnerable.. TLS v1.2 or v1.3 should be used instead.
 * @kind path-problem
 * @problem.severity error
 * @security-severity TODO
 * @precision high
 * @id swift/insecure-tls
 * @tags security
 *       external/cwe/cwe-757
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import DataFlow::PathGraph

/**
 * A taint config to detect insecure configuration of `NSURLSessionConfiguration`
 */
class InsecureTlsConfig extends TaintTracking::Configuration {
  InsecureTlsConfig() { this = "InsecureTLSConfig" }

  /**
   * Holds for enum values that represent an insecure version of TLS
   */
  override predicate isSource(DataFlow::Node node) {
    exists(MethodRefExpr expr, EnumElementDecl enum, string enumName |
      node.asExpr() = expr and
      expr.getMember() = enum and
      enumName = enum.getName() and
      enumName in ["TLSv10", "TLSv11", "tlsProtocol10", "tlsProtocol11"]
    )
  }

  /**
   * Holds for assignment of TLS-related properties of `NSURLSessionConfiguration`
   */
  override predicate isSink(DataFlow::Node node) {
    exists(AssignExpr assign, MemberRefExpr member, string memberName |
      assign.getSource() = node.asExpr() and
      assign.getDest() = member and
      memberName = member.getMember().(ConcreteVarDecl).getName() and
      memberName in [
          "tlsMinimumSupportedProtocolVersion", "tlsMinimumSupportedProtocol",
          "tlsMaximumSupportedProtocolVersion", "tlsMaximumSupportedProtocol"
        ]
    )
  }
}

from InsecureTlsConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "Insecure TLS configuration"
