/**
 * @name Bad parity check
 * @description Ensure that parity checks take negative numbers into account.
 * @kind problem
 * @problem.severity recommendation
 * @id js/incomplete-parity-check
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-480
 * @precision low
 * @deprecated This query is prone to false positives. Deprecated since 1.17.
 */

import javascript

/*
 * The following predicates implement a simple analysis for identifying
 * expressions that are guaranteed to only evaluate to non-negative numbers:
 *
 *  - non-negative number literals
 *  - applications of (), ++, + to expressions known to be non-negative
 *  - references to local variables that are only assigned non-negative values,
 *    never decremented, and never subjected to any compound assignments except
 *    += where the rhs is known to be non-negative
 *
 * This is a greatest-fixpoint problem: if we have `x = 0`, `y = x`, `x = y`,
 * we want to conclude that both `x` and `y` are non-negative. Hence we have
 * to implement the analysis the other way around, as a conservative check
 * for negativity.
 */

/**
 * Holds if `e` is an expression that is relevant for the maybe-negative analysis.
 */
predicate relevant(Expr e) {
  // base case: left operands of `%`
  exists(ModExpr me | e = me.getLeftOperand())
  or
  // first inductive case: downward AST traversal
  relevant(e.getParentExpr())
  or
  // second inductive case: following variable assignments
  exists(Variable v | relevant(v.getAnAccess()) | e = v.getAnAssignedExpr())
}

/** Holds if `e` could evaluate to a negative number. */
predicate maybeNegative(Expr e) {
  relevant(e) and
  if exists(e.getIntValue())
  then e.getIntValue() < 0
  else
    if e instanceof ParExpr
    then maybeNegative(e.(ParExpr).getExpression())
    else
      if e instanceof IncExpr
      then maybeNegative(e.(IncExpr).getOperand())
      else
        if e instanceof VarAccess
        then maybeNegativeVar(e.(VarAccess).getVariable())
        else
          if e instanceof AddExpr
          then maybeNegative(e.(AddExpr).getAnOperand())
          else
            // anything else is considered to possibly be negative
            any()
}

/** Holds if `v` could be assigned a negative number. */
predicate maybeNegativeVar(Variable v) {
  v.isGlobal()
  or
  v.isParameter()
  or
  // is v ever assigned a potentially negative value?
  maybeNegative(v.getAnAssignedExpr())
  or
  // is v ever decremented?
  exists(DecExpr dec | dec.getOperand().getUnderlyingReference() = v.getAnAccess())
  or
  // is v ever subject to a compound assignment other than +=, or to
  // += with potentially negative rhs?
  exists(CompoundAssignExpr assgn | assgn.getTarget() = v.getAnAccess() |
    not assgn instanceof AssignAddExpr or
    maybeNegative(assgn.getRhs())
  )
}

from Comparison cmp, ModExpr me, int num, string parity
where
  cmp.getAnOperand().stripParens() = me and
  cmp.getAnOperand().getIntValue() = num and
  me.getRightOperand().getIntValue() = 2 and
  maybeNegative(me.getLeftOperand()) and
  (
    (cmp instanceof EqExpr or cmp instanceof StrictEqExpr) and
    num = 1 and
    parity = "oddness"
    or
    (cmp instanceof NEqExpr or cmp instanceof StrictNEqExpr) and
    num = 1 and
    parity = "evenness"
    or
    cmp instanceof GTExpr and num = 0 and parity = "oddness"
  )
select cmp, "Test for " + parity + " does not take negative numbers into account."
