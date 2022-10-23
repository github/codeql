/**
 * @name Insufficient hash iterations
 * @description Using hash functions with < 1000 iterations is not secure, because that scheme leads to password cracking attacks due to having an insufficient level of computational effort.
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
 * A literal integer that is 1000 or less is a source of taint for iterations.
 */
class IntLiteralSource extends IterationsSource instanceof IntegerLiteralExpr {
  IntLiteralSource() { this.getStringValue().toInt() < 1000 }
}

/**
 * A class for all ways to set the iterations of hash function.
 */
class InsufficientHashIterationsSink extends Expr {
  InsufficientHashIterationsSink() {
    // `iterations` arg in `init` is a sink
    exists(ClassOrStructDecl c, AbstractFunctionDecl f, CallExpr call, int arg |
      c.getFullName() = ["PBKDF1", "PBKDF2"] and
      c.getAMember() = f and
      f.getName().matches("init(%iterations:%") and
      call.getStaticTarget() = f and
      f.getParam(pragma[only_bind_into](arg)).getName() = "iterations" and
      call.getArgument(pragma[only_bind_into](arg)).getExpr() = this
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
  "The variable '" + sinkNode.getNode().toString() +
    "' is an insufficient number of iterations, which is not secure for hash functions.",
  sourceNode, sourceNode.getNode().toString()
