/**
 * @name Use of constant salts
 * @description Using constant salts for password hashing is not secure because potential attackers can precompute the hash value via dictionary attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/constant-salt
 * @tags security
 *       external/cwe/cwe-760
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSteps
import DataFlow::PathGraph

/**
 * A constant salt is created through either a byte array or string literals.
 */
class ConstantSaltSource extends Expr {
  ConstantSaltSource() {
    this = any(ArrayExpr arr | arr.getType().getName() = "Array<UInt8>") or
    this instanceof StringLiteralExpr
  }
}

/**
 * A class for all ways to use a constant salt.
 */
class ConstantSaltSink extends Expr {
  ConstantSaltSink() {
    // `salt` arg in `init` is a sink
    exists(ClassOrStructDecl c, ConstructorDecl f, CallExpr call |
      c.getFullName() = ["HKDF", "PBKDF1", "PBKDF2", "Scrypt"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("salt").getExpr() = this
    )
  }
}

/**
 * A taint configuration from the source of constants salts to expressions that use
 * them to initialize password-based enecryption keys.
 */
class ConstantSaltConfig extends TaintTracking::Configuration {
  ConstantSaltConfig() { this = "ConstantSaltConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof ConstantSaltSource }

  override predicate isSink(DataFlow::Node node) { node.asExpr() instanceof ConstantSaltSink }
}

// The query itself
from ConstantSaltConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The value '" + sourceNode.getNode().toString() +
    "' is used as a constant salt, which is insecure for hashing passwords."
