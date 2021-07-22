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

/**
 * Gets an operand of a logical operation expression (we need the restriction
 * to BinaryLogicalOperation expressions to get the correct transitive closure).
 */
Expr getComparisonOperand(BinaryLogicalOperation op) { result = op.getAnOperand() }

class BooleanControllingAssignmentInExpr extends BooleanControllingAssignment {
  BooleanControllingAssignmentInExpr() {
    this.getParent() instanceof UnaryLogicalOperation or
    this.getParent() instanceof BinaryLogicalOperation or
    exists(ConditionalExpr c | c.getCondition() = this)
  }

  override predicate isWhitelisted() {
    this.getConversion().(ParenthesisExpr).isParenthesised()
    or
    // Allow this assignment if all comparison operations in the expression that this
    // assignment is part of, are not parenthesized. In that case it seems like programmer
    // is fine with unparenthesized comparison operands to binary logical operators, and
    // the parenthesis around this assignment was used to call it out as an assignment.
    this.isParenthesised() and
    forex(ComparisonOperation op | op = getComparisonOperand*(this.getParent+()) |
      not op.isParenthesised()
    )
    or
    // Match a pattern like:
    // ```
    // if((a = b) && use_value(a)) { ... }
    // ```
    // where the assignment is meant to update the value of `a` before it's used in some other boolean
    // subexpression that is guarenteed to be evaluate _after_ the assignment.
    this.isParenthesised() and
    exists(LogicalAndExpr parent, Variable var, VariableAccess access |
      var = this.getLValue().(VariableAccess).getTarget() and
      access = var.getAnAccess() and
      not access.isUsedAsLValue() and
      parent.getRightOperand() = access.getParent*() and
      parent.getLeftOperand() = this.getParent*()
    )
  }
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
  not ae.isWhitelisted() and
  not ae.getRValue() instanceof StringLiteral
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
  not ae.isFromUninstantiatedTemplate(_) and
  not undef.reaches(_, ae.getLValue().(VariableAccess).getTarget(), ae.getLValue())
select ae, "Use of '=' where '==' may have been intended."
