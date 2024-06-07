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
 * A barrier for cleartext transmission vulnerabilities.
 */
abstract class CleartextTransmissionBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class CleartextTransmissionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to cleartext transmission vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * An `Expr` that transmitted through the Alamofire library.
 */
private class AlamofireTransmittedSink extends CleartextTransmissionSink {
  AlamofireTransmittedSink() {
    // sinks are the first argument containing the URL, and the `parameters`
    // and `headers` arguments to appropriate methods of `Session`.
    exists(CallExpr call, string fName |
      call.getStaticTarget().(Method).hasQualifiedName("Session", fName) and
      fName.regexpMatch("(request|streamRequest|download)\\(.*") and
      (
        call.getArgument(0).getExpr() = this.asExpr() or
        call.getArgumentWithLabel(["headers", "parameters"]).getExpr() = this.asExpr()
      )
    )
  }
}

/**
 * A barrier for cleartext transmission vulnerabilities.
 *  - encryption; encrypted values are not cleartext.
 *  - booleans; these are more likely to be settings, rather than actual sensitive data.
 */
private class CleartextTransmissionDefaultBarrier extends CleartextTransmissionBarrier {
  CleartextTransmissionDefaultBarrier() {
    this.asExpr() instanceof EncryptedExpr or
    this.asExpr().getType().getUnderlyingType() instanceof BoolType
  }
}

/**
 * An additional taint step for cleartext transmission vulnerabilities.
 */
private class CleartextTransmissionFieldAdditionalFlowStep extends CleartextTransmissionAdditionalFlowStep
{
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // if an object is sensitive, its fields are always sensitive.
    nodeTo.asExpr().(MemberRefExpr).getBase() = nodeFrom.asExpr()
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCleartextTransmissionSink extends CleartextTransmissionSink {
  DefaultCleartextTransmissionSink() { sinkNode(this, "transmission") }
}

private class TransmissionSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NWConnection;true;send(content:contentContext:isComplete:completion:);;;Argument[0];transmission",
        // an `Expr` that is used to form a `URL` is very likely to be transmitted over a network, because
        // that's what URLs are for.
        ";URL;true;init(string:);;;Argument[0];transmission",
        ";URL;true;init(string:relativeTo:);;;Argument[0];transmission",
      ]
  }
}
