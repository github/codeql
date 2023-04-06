/**
 * Provides classes and predicates for reasoning about insecure TLS
 * configurations.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A dataflow source for insecure TLS configuration vulnerabilities. That is,
 * a `DataFlow::Node` for something that is an insecure TLS version.
 */
abstract class InsecureTlsExtensionsSource extends DataFlow::Node { }

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
 * A source for enum values that represent an insecure version of TLS.
 */
private class EnumInsecureTlsExtensionsSource extends InsecureTlsExtensionsSource {
  EnumInsecureTlsExtensionsSource() {
    this.asExpr().(MethodLookupExpr).getMember().(EnumElementDecl).getName() =
      ["TLSv10", "TLSv11", "tlsProtocol10", "tlsProtocol11"]
  }
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
