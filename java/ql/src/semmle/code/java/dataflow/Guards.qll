import java
private import semmle.code.java.controlflow.Guards as Guards
private import semmle.code.java.controlflow.Dominance

/**
 * DEPRECATED: Use semmle.code.java.controlflow.Guards instead.
 *
 * A basic block that terminates in a condition, splitting the subsequent control flow.
 */
deprecated
class ConditionBlock = Guards::ConditionBlock;

/** Holds if `n` updates the locally scoped variable `v`. */
deprecated
predicate variableUpdate(ControlFlowNode n, LocalScopeVariable v) {
  exists(VariableUpdate a | a = n | a.getDestVar() = v)
}

/** Holds if `bb` updates the locally scoped variable `v`. */
deprecated private predicate variableUpdateBB(BasicBlock bb, LocalScopeVariable v) {
  variableUpdate(bb.getANode(), v)
}

/** Indicates the position of phi-nodes in an SSA representation. */
deprecated private predicate needPhiNode(BasicBlock bb, LocalScopeVariable v) {
  exists(BasicBlock def | dominanceFrontier(def, bb) |
    variableUpdateBB(def, v) or needPhiNode(def, v)
  )
}

/** Locally scoped variable `v` occurs in the condition of `cb`. */
deprecated private predicate relevantVar(ConditionBlock cb, LocalScopeVariable v) {
  v.getAnAccess() = cb.getCondition().getAChildExpr*()
}

/** Blocks controlled by the condition in `cb` for which `v` is unchanged. */
deprecated private predicate controlsBlockWithSameVar(ConditionBlock cb, boolean testIsTrue, LocalScopeVariable v, BasicBlock controlled) {
  cb.controls(controlled, testIsTrue) and
  relevantVar(cb, v) and
  not needPhiNode(controlled, v) and
  (
    controlled = cb.getTestSuccessor(testIsTrue)
    or
    exists(BasicBlock mid |
      controlsBlockWithSameVar(cb, testIsTrue, v, mid) and
      not variableUpdateBB(mid, v) and
      controlled = mid.getABBSuccessor()
    )
  )
}

/**
 * DEPRECATED: Use semmle.code.java.dataflow.SSA instead.
 *
 * Statements controlled by the condition in `s` for which `v` is unchanged (`v` is the same SSA
 * variable in both `s` and `controlled`). The condition in `s` must contain an access of `v`.
 */
deprecated
predicate controlsNodeWithSameVar(ConditionNode cn, boolean testIsTrue, LocalScopeVariable v, ControlFlowNode controlled) {
  exists(ConditionBlock cb, BasicBlock controlledBB, int i |
    cb.getConditionNode() = cn and
    controlsBlockWithSameVar(cb, testIsTrue, v, controlledBB) and
    controlled = controlledBB.getNode(i) and
    not exists(ControlFlowNode update, int j | update = controlledBB.getNode(j) and j < i and variableUpdate(update, v)))
}
