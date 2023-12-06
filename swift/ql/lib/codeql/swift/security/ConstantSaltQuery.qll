/**
 * Provides a taint tracking configuration to find use of constant salts
 * for password hashing.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSteps
import codeql.swift.security.ConstantSaltExtensions

/**
 * A constant salt is created through either a byte array or string literals.
 */
class ConstantSaltSource extends Expr {
  ConstantSaltSource() {
    this = any(ArrayExpr arr | arr.getType().getName() = "Array<UInt8>") or
    this instanceof StringLiteralExpr or
    this instanceof NumberLiteralExpr
  }
}

/**
 * A taint configuration from the source of constants salts to expressions that use
 * them to initialize password-based encryption keys.
 */
module ConstantSaltConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof ConstantSaltSource }

  predicate isSink(DataFlow::Node node) { node instanceof ConstantSaltSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof ConstantSaltBarrier }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(ConstantSaltAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

module ConstantSaltFlow = TaintTracking::Global<ConstantSaltConfig>;
