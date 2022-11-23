/**
 * @name Cleartext transmission of sensitive information
 * @description Transmitting sensitive information across a network in
 *              cleartext can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id swift/cleartext-transmission
 * @tags security
 *       external/cwe/cwe-319
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * An `Expr` that is transmitted over a network.
 */
abstract class Transmitted extends Expr { }

/**
 * An `Expr` that is transmitted with `NWConnection.send`.
 */
class NWConnectionSend extends Transmitted {
  NWConnectionSend() {
    // `content` arg to `NWConnection.send` is a sink
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("NWConnection", "send(content:contentContext:isComplete:completion:)") and
      call.getArgument(0).getExpr() = this
    )
  }
}

/**
 * An `Expr` that is used to form a `URL`. Such expressions are very likely to
 * be transmitted over a network, because that's what URLs are for.
 */
class Url extends Transmitted {
  Url() {
    // `string` arg in `URL.init` is a sink
    // (we assume here that the URL goes on to be used in a network operation)
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("URL", ["init(string:)", "init(string:relativeTo:)"]) and
      call.getArgument(0).getExpr() = this
    )
  }
}

/**
 * An `Expr` that transmitted through the Alamofire library.
 */
class AlamofireTransmitted extends Transmitted {
  AlamofireTransmitted() {
    // sinks are the first argument containing the URL, and the `parameters`
    // and `headers` arguments to appropriate methods of `Session`.
    exists(CallExpr call, string fName |
      call.getStaticTarget().(MethodDecl).hasQualifiedName("Session", fName) and
      fName.regexpMatch("(request|streamRequest|download)\\(.*") and
      (
        call.getArgument(0).getExpr() = this or
        call.getArgumentWithLabel(["headers", "parameters"]).getExpr() = this
      )
    )
  }
}

/**
 * A taint configuration from sensitive information to expressions that are
 * transmitted over a network.
 */
class CleartextTransmissionConfig extends TaintTracking::Configuration {
  CleartextTransmissionConfig() { this = "CleartextTransmissionConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node node) { node.asExpr() instanceof Transmitted }

  override predicate isSanitizerIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    // encryption barrier
    node.asExpr() instanceof EncryptedExpr
  }
}

from CleartextTransmissionConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This operation transmits '" + sinkNode.getNode().toString() +
    "', which may contain unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
