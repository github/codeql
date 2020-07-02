/*
 * For two-operand conditional expressions, the extractor previously did not
 * emit an expr_cond_true tuple, and ConditionalExpr::getThen() was implemented
 * as
 *   if this.isTwoOperand()
 *     then result = this.getCondition()
 *     else expr_cond_true(underlyingElement(this), unresolveElement(result))
 *
 * Now that the extractor always emits expr_cond_true (using a synthesized
 * expression node for the two-operand case), and getThen() has been simplified
 * to
 *   expr_cond_true(underlyingElement(this), unresolveElement(result))
 * this upgrade script approximates the new extractor behaviour.
 *
 * Any existing expr_cond_true tuples are kept (i.e. for the regular
 * three-operand expressions).
 *
 * New expr_cond_true tuples are created for two-operand conditional
 * expressions, referring to the guard/condition expression as the 'then' case.
 */

class ConditionalExpr extends @conditionalexpr {
  string toString() { result = "conditional expr" }
}

class Expr extends @expr {
  string toString() { result = "expr" }
}

from ConditionalExpr c, Expr e
where if expr_cond_two_operand(c) then expr_cond_guard(c, e) else expr_cond_true(c, e)
select c, e
