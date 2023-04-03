/**
 * Provides a taint tracking configuration to find insufficient hash
 * iteration vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.InsufficientHashIterationsQuery

/**
 * An `Expr` that is used to initialize a password-based encryption key.
 */
abstract class IterationsSource extends Expr { }

/**
 * A literal integer that is 120,000 or less is a source of taint for iterations.
 */
class IntLiteralSource extends IterationsSource instanceof IntegerLiteralExpr {
  IntLiteralSource() { this.getStringValue().toInt() < 120000 }
}

/**
 * A class for all ways to set the iterations of hash function.
 */
class InsufficientHashIterationsSink extends Expr {
  InsufficientHashIterationsSink() {
    // `iterations` arg in `init` is a sink
    exists(ClassOrStructDecl c, ConstructorDecl f, CallExpr call |
      c.getName() = ["PBKDF1", "PBKDF2"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("iterations").getExpr() = this
    )
  }
}

/**
 * A dataflow configuration from the hash iterations source to expressions that use
 * it to initialize hash functions.
 */
module InsufficientHashIterationsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof IterationsSource }

  predicate isSink(DataFlow::Node node) { node.asExpr() instanceof InsufficientHashIterationsSink }
}

module InsufficientHashIterationsFlow = TaintTracking::Global<InsufficientHashIterationsConfig>;
