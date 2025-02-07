/**
 * @name Database query in a loop
 * @description Database queries in a loop can lead to an unnecessary amount of database calls and poor performance.
 * @kind problem
 * @problem.severity info
 * @precision high
 * @id rb/database-query-in-loop
 * @tags performance
 */

import ruby
private import codeql.ruby.AST
import codeql.ruby.ast.internal.Constant
import codeql.ruby.Concepts
import codeql.ruby.frameworks.ActiveRecord
private import codeql.ruby.TaintTracking

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

/** Holds if `ar` influences `guard`, which may control the execution of a loop. */
predicate usedInLoopControlGuard(ActiveRecordInstance ar, DataFlow::Node guard) {
  TaintTracking::localTaint(ar, guard) and
  guard = guardForLoopControl(_, _)
}

/** Gets a dataflow node that is used to decide whether to break a loop. */
DataFlow::Node guardForLoopControl(ConditionalExpr cond, Stmt control) {
  result.asExpr().getAstNode() = cond.getCondition().getAChild*() and
  (
    control.(MethodCall).getMethodName() = "raise"
    or
    control instanceof NextStmt
  ) and
  control = cond.getBranch(_).getAChild()
}

from LoopingCall loop, ActiveRecordModelFinderCall call
where
  loop.executesCall(call) and
  // Disregard loops over constants
  not isArrayConstant(loop.getReceiver().asExpr(), _) and
  // Disregard cases where the looping is influenced by the query result
  not usedInLoopControlGuard(call, _) and
  // Only report calls that are likely to be expensive
  not call.getMethodName() in ["new", "create"]
select call,
  "This call to a database query operation happens inside $@, and could be hoisted to a single call outside the loop.",
  loop, "this loop"
