/**
 * @name Constant password
 * @description Using constant passwords is not secure, because potential attackers can easily recover them from the source code.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.8
 * @precision high
 * @id swift/constant-password
 * @tags security
 *       external/cwe/cwe-259
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSteps
import ConstantPasswordFlow::PathGraph

/**
 * A constant password is created through either a byte array or string literals.
 */
class ConstantPasswordSource extends Expr {
  ConstantPasswordSource() {
    this = any(ArrayExpr arr | arr.getType().getName() = "Array<UInt8>") or
    this instanceof StringLiteralExpr
  }
}

/**
 * A class for all ways to use a constant password.
 */
class ConstantPasswordSink extends Expr {
  ConstantPasswordSink() {
    // `password` arg in `init` is a sink
    exists(ClassOrStructDecl c, ConstructorDecl f, CallExpr call |
      c.getName() = ["HKDF", "PBKDF1", "PBKDF2", "Scrypt"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("password").getExpr() = this
    )
    or
    // RNCryptor (labelled arguments)
    exists(ClassOrStructDecl c, MethodDecl f, CallExpr call |
      c.getName() = ["RNCryptor", "RNEncryptor", "RNDecryptor"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["password", "withPassword", "forPassword"]).getExpr() = this
    )
    or
    // RNCryptor (unlabelled arguments)
    exists(MethodDecl f, CallExpr call |
      f.hasQualifiedName("RNCryptor", "keyForPassword(_:salt:settings:)") and
      call.getStaticTarget() = f and
      call.getArgument(0).getExpr() = this
    )
  }
}

/**
 * A taint configuration from the source of constants passwords to expressions that use
 * them to initialize password-based encryption keys.
 */
module ConstantPasswordConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof ConstantPasswordSource }

  predicate isSink(DataFlow::Node node) { node.asExpr() instanceof ConstantPasswordSink }
}

module ConstantPasswordFlow = TaintTracking::Global<ConstantPasswordConfig>;

// The query itself
from ConstantPasswordFlow::PathNode sourceNode, ConstantPasswordFlow::PathNode sinkNode
where ConstantPasswordFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The value '" + sourceNode.getNode().toString() + "' is used as a constant password."
