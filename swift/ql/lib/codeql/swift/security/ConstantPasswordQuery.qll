/**
 * Provides a taint tracking configuration to find constant password
 * vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSteps
import codeql.swift.security.ConstantPasswordExtensions

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
 * A taint configuration from the source of constants passwords to expressions that use
 * them to initialize password-based encryption keys.
 */
module ConstantPasswordConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof ConstantPasswordSource }

  predicate isSink(DataFlow::Node node) { node instanceof ConstantPasswordSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof ConstantPasswordSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(ConstantPasswordAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

module ConstantPasswordFlow = TaintTracking::Global<ConstantPasswordConfig>;
