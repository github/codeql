/**
 * @name Assignment where comparison was intended
 * @description The '=' operator may have been used accidentally, where '=='
 *              was intended.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/assign-where-compare-meant
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-481
 */

import cpp
import semmle.code.cpp.controlflow.StackVariableReachability

class UndefReachability extends StackVariableReachability {
  UndefReachability() { this = "UndefReachability" }

  override predicate isSource(ControlFlowNode node, StackVariable v) {
    candidateVariable(v) and
    node = v.getParentScope() and
    not v instanceof Parameter and
    not v.hasInitializer()
  }

  override predicate isSink(ControlFlowNode node, StackVariable v) {
    candidateVariable(v) and
    node = v.getAnAccess()
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) {
    node.(AssignExpr).getLValue() = v.getAnAccess()
  }
}

abstract class BooleanControllingAssignment extends AssignExpr {
  abstract predicate isWhitelisted();
}

class BooleanControllingAssignmentInExpr extends BooleanControllingAssignment {
  BooleanControllingAssignmentInExpr() {
    this.getParent() instanceof UnaryLogicalOperation or
    this.getParent() instanceof BinaryLogicalOperation or
    exists(ConditionalExpr c | c.getCondition() = this)
  }

  override predicate isWhitelisted() { this.getConversion().(ParenthesisExpr).isParenthesised() }
}

class BooleanControllingAssignmentInStmt extends BooleanControllingAssignment {
  BooleanControllingAssignmentInStmt() {
    exists(IfStmt i | i.getCondition() = this) or
    exists(ForStmt f | f.getCondition() = this) or
    exists(WhileStmt w | w.getCondition() = this) or
    exists(DoStmt d | d.getCondition() = this)
  }

  override predicate isWhitelisted() { this.isParenthesised() }
}

/**
 * Holds if `ae` is a `BooleanControllingAssignment` that would be a result of this query,
 * before checking for undef reachability.
 */
predicate candidateResult(BooleanControllingAssignment ae) {
  ae.getRValue().isConstant() and
  not ae.isWhitelisted()
}

/**
 * Holds if `v` is a `Variable` that might be assigned to in a result of this query.
 */
predicate candidateVariable(Variable v) {
  exists(BooleanControllingAssignment ae |
    candidateResult(ae) and
    ae.getLValue().(VariableAccess).getTarget() = v
  )
}

from BooleanControllingAssignment ae, UndefReachability undef
where
  candidateResult(ae) and
  not undef.reaches(_, ae.getLValue().(VariableAccess).getTarget(), ae.getLValue())
select ae, "Use of '=' where '==' may have been intended."
