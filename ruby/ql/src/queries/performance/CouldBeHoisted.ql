/**
 * @name Could be hoisted
 * @description Hoist Rails `ActiveRecord::Relation` query calls out of loops.
 * @kind problem
 * @problem.severity info
 * @precision high
 * @id rb/could-be-hoisted
 * @tags performance
 */

// Possible Improvements;
// - Consider also Associations.
//   Associations are lazy-loading by default, so something like
//   in a loop over `article` do
//      `article.book`
//   if you have 1000 articles it will do a 1000 calls to `book`.
//   If you already did `article includes book`, there should be no problem.
// - Consider instances of ActiveRecordInstanceMethodCall, for instance
//   calls to `pluck`.
import ruby
private import codeql.ruby.AST
import codeql.ruby.ast.internal.Constant
import codeql.ruby.Concepts
import codeql.ruby.frameworks.ActiveRecord
private import codeql.ruby.TaintTracking

string loopMethodName() {
  result in [
      "each", "reverse_each", "map", "map!", "foreach", "flat_map", "in_batches", "one?", "all?",
      "collect", "collect!", "select", "select!", "reject", "reject!"
    ]
}

class LoopingCall extends DataFlow::CallNode {
  DataFlow::CallableNode loopBlock;

  LoopingCall() {
    this.getMethodName() = loopMethodName() and loopBlock = this.getBlock().asCallable()
  }

  DataFlow::CallableNode getLoopBlock() { result = loopBlock }
}

predicate happensInLoop(LoopingCall loop, DataFlow::CallNode e) {
  loop.getLoopBlock().asCallableAstNode() = e.asExpr().getScope()
}

predicate happensInOuterLoop(LoopingCall outerLoop, DataFlow::CallNode e) {
  exists(LoopingCall innerLoop |
    happensInLoop(outerLoop, innerLoop) and
    happensInLoop(innerLoop, e)
  )
}

predicate happensInInnermostLoop(LoopingCall loop, DataFlow::CallNode e) {
  happensInLoop(loop, e) and
  not happensInOuterLoop(loop, e)
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
  // Disregard tests
  not call.getLocation().getFile().getAbsolutePath().matches("%test%") and
  // Disregard cases where the looping is influenced by the query result
  not usedInLoopControlGuard(call, _) and
  // Only report the inner most loop
  happensInInnermostLoop(loop, call) and
  // Only report calls that are likely to be expensive
  call instanceof ActiveRecordModelFinderCall and
  not call.getMethodName() in ["new", "create"]
select call, "This call happens inside $@, and could be hoisted.", loop, "this loop"
