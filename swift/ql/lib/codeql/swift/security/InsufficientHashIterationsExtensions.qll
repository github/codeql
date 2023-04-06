/**
 * Provides classes and predicates for reasoning about insufficient hash
 * iteration vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A dataflow sink for insufficient hash interation vulnerabilities. That is,
 * a `DataFlow::Node` of something that is used as the iteration count of a
 * hash function.
 */
abstract class InsufficientHashIterationsSink extends DataFlow::Node { }

/**
 * A sanitizer for insufficient hash interation vulnerabilities.
 */
abstract class InsufficientHashIterationsSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class InsufficientHashIterationsAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for paths related to insufficient hash interation vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink for the CryptoSwift library.
 */
private class CryptoSwiftHashIterationsSink extends InsufficientHashIterationsSink {
  CryptoSwiftHashIterationsSink() {
    // `iterations` arg in `init` is a sink
    exists(ClassOrStructDecl c, ConstructorDecl f, CallExpr call |
      c.getName() = ["PBKDF1", "PBKDF2"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("iterations").getExpr() = this.asExpr()
    )
  }
}
