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
import StaticInitializationVectorFlow::PathGraph

/**
 * A static IV is created through either a byte array or string literals.
 */
class StaticInitializationVectorSource extends Expr {
  StaticInitializationVectorSource() {
    this instanceof ArrayExpr or
    this instanceof StringLiteralExpr or
    this instanceof NumberLiteralExpr
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
    or
    // RNCryptor
    exists(ClassOrStructDecl c, MethodDecl f, CallExpr call |
      c.getFullName() = ["RNCryptor", "RNEncryptor", "RNDecryptor"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["iv", "IV"]).getExpr() = this
    )
  }
}

/**
 * A dataflow configuration from the source of a static IV to expressions that use
 * it to initialize a cipher.
 */
module StaticInitializationVectorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof StaticInitializationVectorSource
  }

  predicate isSink(DataFlow::Node node) { node.asExpr() instanceof EncryptionInitializationSink }
}

module StaticInitializationVectorFlow = TaintTracking::Global<StaticInitializationVectorConfig>;

// The query itself
from
  StaticInitializationVectorFlow::PathNode sourceNode,
  StaticInitializationVectorFlow::PathNode sinkNode
where StaticInitializationVectorFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The static value '" + sourceNode.getNode().toString() +
    "' is used as an initialization vector for encryption."
