/**
 * @name Static initialization vector for encryption
 * @description Using a static initialization vector (IV) for encryption is not secure. To maximize encryption and prevent dictionary attacks, IVs should be unique and unpredictable.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/static-initialization-vector
 * @tags security
 *       external/cwe/cwe-329
 *       external/cwe/cwe-1204
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A static IV is created through either a byte array or string literals.
 */
class StaticInitializationVectorSource extends Expr {
  StaticInitializationVectorSource() {
    this = any(ArrayExpr arr | arr.getType().getName() = "Array<UInt8>") or
    this instanceof StringLiteralExpr
  }
}

/**
 * A class for all ways to set an IV.
 */
class EncryptionInitializationSink extends Expr {
  EncryptionInitializationSink() {
    // `iv` arg in `init` is a sink
    exists(InitializerCallExpr call |
      call.getStaticTarget()
          .hasQualifiedName([
              "AES", "ChaCha20", "Blowfish", "Rabbit", "CBC", "CFB", "GCM", "OCB", "OFB", "PCBC",
              "CCM", "CTR"
            ], _) and
      call.getArgumentWithLabel("iv").getExpr() = this
    )
  }
}

/**
 * A dataflow configuration from the source of a static IV to expressions that use
 * it to initialize a cipher.
 */
class StaticInitializationVectorConfig extends TaintTracking::Configuration {
  StaticInitializationVectorConfig() { this = "StaticInitializationVectorConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof StaticInitializationVectorSource
  }

  override predicate isSink(DataFlow::Node node) {
    node.asExpr() instanceof EncryptionInitializationSink
  }
}

// The query itself
from
  StaticInitializationVectorConfig config, DataFlow::PathNode sourceNode,
  DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The static value '" + sourceNode.getNode().toString() +
    "' is used as an initialization vector for encryption."
