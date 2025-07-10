/**
 * @name Database query in a loop
 * @description Database queries in a loop can lead to an unnecessary amount of database calls and poor performance.
 * @kind problem
 * @problem.severity info
 * @precision high
 * @id rb/database-query-in-loop
 * @tags performance
 *       quality
 */

import ruby
private import codeql.ruby.AST
import codeql.ruby.ast.internal.Constant
import codeql.ruby.Concepts
import codeql.ruby.frameworks.ActiveRecord
private import codeql.ruby.TaintTracking
private import codeql.ruby.CFG
private import codeql.ruby.controlflow.internal.Guards as Guards

/** Gets the name of a built-in method that involves a loop operation. */
string getALoopMethodName() {
  result in [
      "each", "reverse_each", "map", "map!", "foreach", "flat_map", "in_batches", "one?", "all?",
      "collect", "collect!", "select", "select!", "reject", "reject!"
    ]
}

/** A loop, represented by a call to a loop operation. */
class LoopingCall extends DataFlow::CallNode {
  Callable loopScope;

  LoopingCall() {
    this.getMethodName() = getALoopMethodName() and
    loopScope = this.getBlock().asCallable().asCallableAstNode()
  }

  /** Holds if `c` is executed as part of the body of this loop. */
  predicate executesCall(DataFlow::CallNode c) { c.asExpr().getScope() = loopScope }
}

/** Holds if `ar` influences a guard that may control the execution of a loop. */
predicate usedInLoopControlGuard(ActiveRecordInstance ar) {
  exists(DataFlow::Node insideGuard, CfgNodes::ExprCfgNode guard |
    // For a guard like `cond && ar`, the whole guard will not be tainted
    // so we need to look at the taint of the individual parts.
    insideGuard.asExpr().getExpr() = guard.getExpr().getAChild*()
  |
    TaintTracking::localTaint(ar, insideGuard) and
    guardForLoopControl(guard, _)
  )
}

/** Holds if `guard` controls `break` and `break` would break out of a loop. */
predicate guardForLoopControl(CfgNodes::ExprCfgNode guard, CfgNodes::AstCfgNode break) {
  Guards::guardControlsBlock(guard, break.getBasicBlock(), _) and
  (
    break.(CfgNodes::ExprNodes::MethodCallCfgNode).getMethodName() = "raise"
    or
    break instanceof CfgNodes::ReturningCfgNode
  )
}

from LoopingCall loop, ActiveRecordModelFinderCall call
where
  loop.executesCall(call) and
  // Disregard loops over constants
  not isArrayConstant(loop.getReceiver().asExpr(), _) and
  // Disregard cases where the looping is influenced by the query result
  not usedInLoopControlGuard(call) and
  // Only report calls that are likely to be expensive
  not call.getMethodName() in ["new", "create"]
select call,
  "This call to a database query operation happens inside $@, and could be hoisted to a single call outside the loop.",
  loop, "this loop"
