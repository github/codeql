/**
 * @name Insufficient hash iterations
 * @description Using hash functions with fewer than 120,000 iterations is insufficient to protect passwords because a cracking attack will require a low level of computational effort.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id swift/insufficient-hash-iterations
 * @tags security
 *       external/cwe/cwe-916
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

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
      c.getFullName() = ["PBKDF1", "PBKDF2"] and
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
class InsufficientHashIterationsConfig extends TaintTracking::Configuration {
  InsufficientHashIterationsConfig() { this = "InsufficientHashIterationsConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof IterationsSource }

  override predicate isSink(DataFlow::Node node) {
    node.asExpr() instanceof InsufficientHashIterationsSink
  }
}

// The query itself
from
  InsufficientHashIterationsConfig config, DataFlow::PathNode sourceNode,
  DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The value '" + sourceNode.getNode().toString() +
    "' is an insufficient number of iterations for secure password hashing."
