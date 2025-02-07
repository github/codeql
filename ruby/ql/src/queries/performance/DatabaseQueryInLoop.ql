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

/** A call to a loop operation. */
class LoopingCall extends DataFlow::CallNode {
  DataFlow::CallableNode loopBlock;

  LoopingCall() {
    this.getMethodName() = getALoopMethodName() and loopBlock = this.getBlock().asCallable()
  }

  DataFlow::CallableNode getLoopBlock() { result = loopBlock }
}

predicate happensInLoop(LoopingCall loop, DataFlow::CallNode e) {
  loop.getLoopBlock().asCallableAstNode() = e.asExpr().getScope()
}

// The ActiveRecord instance is used to potentially control the loop
predicate usedInLoopControlGuard(ActiveRecordInstance ar, DataFlow::Node guard) {
  TaintTracking::localTaint(ar, guard) and
  guard = guardForLoopControl(_, _)
}

// A guard for controlling the loop
DataFlow::Node guardForLoopControl(ConditionalExpr cond, Stmt control) {
  result.asExpr().getAstNode() = cond.getCondition().getAChild*() and
  (
    control.(MethodCall).getMethodName() = "raise"
    or
    control instanceof NextStmt
  ) and
  control = cond.getBranch(_).getAChild()
}

from LoopingCall loop, DataFlow::CallNode call
where
  // Disregard loops over constants
  not isArrayConstant(loop.getReceiver().asExpr(), _) and
  // Disregard cases where the looping is influenced by the query result
  not usedInLoopControlGuard(call, _) and
  happensInLoop(loop, call) and
  // Only report calls that are likely to be expensive
  call instanceof ActiveRecordModelFinderCall and
  not call.getMethodName() in ["new", "create"]
select call,
  "This call to a database query operation happens inside $@, and could be hoisted to a single call outside the loop.",
  loop, "this loop"
