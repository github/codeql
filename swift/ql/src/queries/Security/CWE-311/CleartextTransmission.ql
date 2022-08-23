/**
 * @name Cleartext transmission of sensitive information
 * @description TODO
 * @kind path-problem
 * @problem.severity TODO
 * @security-severity TODO
 * @precision TODO
 * @id swift/TODO
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
    exists(ClassDecl c, AbstractFunctionDecl f, CallExpr call |
      c.getName() = "NWConnection" and
      c.getAMember() = f and
      f.getName() = "send(content:contentContext:isComplete:completion:)" and
      call.getFunction().(ApplyExpr).getStaticTarget() = f and
      call.getArgument(0).getExpr() = this
    )
  }
}

/**
 * An `Expr` that is used to form a `URL`. Such expressions are very likely to
 * be transmitted over a network, because that's what URLs are for.
 */
class URL extends Transmitted {
  URL() {
    // `string` arg in `URL.init` is a sink
    // (we assume here that the URL goes on to be used in a network operation)
    exists(ClassDecl c, AbstractFunctionDecl f, CallExpr call |
      c.getName() = "URL" and
      c.getAMember() = f and
      f.getName() = ["init(string:)", "init(string:relativeTo:)"] and
      call.getFunction().(ApplyExpr).getStaticTarget() = f and
      call.getArgument(0).getExpr() = this
    )
  }
}

/**
 * A taint configuration from sensitive information to expressions that are
 * transmitted over a network.
 */
class CleartextTransmissionConfig extends TaintTracking::Configuration {
  CleartextTransmissionConfig() { this = "CleartextTransmissionConfig" }

  override predicate isSource(DataFlow::Node node) {
    exists(SensitiveExpr e |
      node.asExpr() = e and
      not e.isProbablySafe()
    )
  }

  override predicate isSink(DataFlow::Node node) { node.asExpr() instanceof Transmitted }
}

from CleartextTransmissionConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This operation transmits '" + sinkNode.getNode().toString() +
    "', which may contain unencrypted sensitive data from $@", sourceNode,
  sourceNode.getNode().toString()
