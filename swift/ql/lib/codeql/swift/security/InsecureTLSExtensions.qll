/**
 * Provides classes and predicates for reasoning about insecure TLS
 * configurations.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A dataflow sink for insecure TLS configuration vulnerabilities. That is,
 * a `DataFlow::Node` of something that is used as a TLS version.
 */
abstract class InsecureTlsExtensionsSink extends DataFlow::Node { }

/**
 * A sanitizer for insecure TLS configuration vulnerabilities.
 */
abstract class InsecureTlsExtensionsSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class InsecureTlsExtensionsAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for paths related to insecure TLS configuration vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink for assignment of TLS-related properties of `NSURLSessionConfiguration`.
 */
private class NsUrlTlsExtensionsSink extends InsecureTlsExtensionsSink {
  NsUrlTlsExtensionsSink() {
    exists(AssignExpr assign |
      assign.getSource() = this.asExpr() and
      assign.getDest().(MemberRefExpr).getMember().(ConcreteVarDecl).getName() =
        [
          "tlsMinimumSupportedProtocolVersion", "tlsMinimumSupportedProtocol",
          "tlsMaximumSupportedProtocolVersion", "tlsMaximumSupportedProtocol"
        ]
    )
  }
}
