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
import DataFlow::PathGraph

/**
 * A constant salt is created through either a byte array or string literals.
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
    exists(ClassOrStructDecl c, AbstractFunctionDecl f, CallExpr call, int arg |
      c.getFullName() = ["HKDF", "PBKDF1", "PBKDF2", "Scrypt"] and
      c.getAMember() = f and
      f.getName().matches("%init(%password:%") and
      call.getStaticTarget() = f and
      f.getParam(pragma[only_bind_into](arg)).getName() = "password" and
      call.getArgument(pragma[only_bind_into](arg)).getExpr() = this
    )
  }
}

/**
 * A taint configuration from the source of constants passwords to expressions that use
 * them to initialize password-based enecryption keys.
 */
class ConstantPasswordConfig extends TaintTracking::Configuration {
  ConstantPasswordConfig() { this = "ConstantPasswordConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof ConstantPasswordSource
  }

  override predicate isSink(DataFlow::Node node) { node.asExpr() instanceof ConstantPasswordSink }
}

// The query itself
from ConstantPasswordConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The value '" + sourceNode.getNode().toString() + "' is used as a constant password."
