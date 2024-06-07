/**
 * Provides a taint tracking configuration to find insufficient hash
 * iteration vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.InsufficientHashIterationsExtensions

/**
 * An `Expr` that is used to initialize a password-based encryption key.
 */
abstract private class IterationsSource extends Expr { }

/**
 * A literal integer that is 120,000 or less is a source of taint for iterations.
 */
private class IntLiteralSource extends IterationsSource instanceof IntegerLiteralExpr {
  IntLiteralSource() { this.getStringValue().toInt() < 120000 }
}

/**
 * A taint tracking configuration from the hash iterations source to expressions that use
 * it to initialize hash functions.
 */
module InsufficientHashIterationsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof IterationsSource }

  predicate isSink(DataFlow::Node node) { node instanceof InsufficientHashIterationsSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof InsufficientHashIterationsBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(InsufficientHashIterationsAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

module InsufficientHashIterationsFlow = TaintTracking::Global<InsufficientHashIterationsConfig>;
