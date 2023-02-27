/**
 * Provides classes and predicates for reasoning about cleartext transmission
 * vulnerabilities.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for cleartext transmission vulnerabilities. That is,
 * a `DataFlow::Node` of something that is transmitted over a network.
 */
abstract class CleartextTransmissionSink extends DataFlow::Node { }

/**
 * A sanitizer for cleartext transmission vulnerabilities.
 */
abstract class CleartextTransmissionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class CleartextTransmissionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for paths related to cleartext transmission vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * An `Expr` that is transmitted with `NWConnection.send`.
 */
private class NWConnectionSendSink extends CleartextTransmissionSink {
  NWConnectionSendSink() {
    // `content` arg to `NWConnection.send` is a sink
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("NWConnection", "send(content:contentContext:isComplete:completion:)") and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }
}

/**
 * An `Expr` that is used to form a `URL`. Such expressions are very likely to
 * be transmitted over a network, because that's what URLs are for.
 */
private class UrlSink extends CleartextTransmissionSink {
  UrlSink() {
    // `string` arg in `URL.init` is a sink
    // (we assume here that the URL goes on to be used in a network operation)
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("URL", ["init(string:)", "init(string:relativeTo:)"]) and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }
}

/**
 * An `Expr` that transmitted through the Alamofire library.
 */
private class AlamofireTransmittedSink extends CleartextTransmissionSink {
  AlamofireTransmittedSink() {
    // sinks are the first argument containing the URL, and the `parameters`
    // and `headers` arguments to appropriate methods of `Session`.
    exists(CallExpr call, string fName |
      call.getStaticTarget().(MethodDecl).hasQualifiedName("Session", fName) and
      fName.regexpMatch("(request|streamRequest|download)\\(.*") and
      (
        call.getArgument(0).getExpr() = this.asExpr() or
        call.getArgumentWithLabel(["headers", "parameters"]).getExpr() = this.asExpr()
      )
    )
  }
}

/**
 * An encryption sanitizer for cleartext transmission vulnerabilities.
 */
private class CleartextTransmissionEncryptionSanitizer extends CleartextTransmissionSanitizer {
  CleartextTransmissionEncryptionSanitizer() { this.asExpr() instanceof EncryptedExpr }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCleartextTransmissionSink extends CleartextTransmissionSink {
  DefaultCleartextTransmissionSink() { sinkNode(this, "transmission") }
}
