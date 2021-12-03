/**
 * Provides all comparison operation classes.
 *
 * All comparison operations have the common base class `ComparisonOperation`.
 */

import Expr

/**
 * A comparison operation. Either an equality operation (`EqualityOperation`)
 * or a relational operation (`RelationalOperation`).
 */
class ComparisonOperation extends BinaryOperation, @comp_expr { }

/**
 * An equality operation. Either an equals operation (`EQExpr`) or a not-equals
 * operation (`NEExpr`).
 */
class EqualityOperation extends ComparisonOperation, @equality_op_expr { }

/**
 * An equals operation, for example `x == y`.
 */
class EQExpr extends EqualityOperation, @eq_expr {
  override string getOperator() { result = "==" }

  override string getAPrimaryQlClass() { result = "EQExpr" }
}

/**
 * A not-equals operation, for example `x != y`.
 */
class NEExpr extends EqualityOperation, @ne_expr {
  override string getOperator() { result = "!=" }

  override string getAPrimaryQlClass() { result = "NEExpr" }
}

/**
 * A relational operation. Either a greater-than operation (`GTExpr`),
 * a less-than operation (`LTExpr`), a greater-than or equals operation
 * (`GEExpr`), or a less-than or equals operation (`LEEexpr`).
 */
class RelationalOperation extends ComparisonOperation, @rel_op_expr {
  /**
   * Gets the operand on the "greater" (or "greater-or-equal") side
   * of this relational expression, that is, the side that is larger
   * if the overall expression evaluates to `true`; for example on
   * `x <= 20` this is the `20`, and on `y > 0` it is `y`.
   */
  Expr getGreaterOperand() { none() }

  /**
   * Gets the operand on the "lesser" (or "lesser-or-equal") side
   * of this relational expression, that is, the side that is smaller
   * if the overall expression evaluates to `true`; for example on
   * `x <= 20` this is `x`, and on `y > 0` it is the `0`.
   */
  Expr getLesserOperand() { none() }

  /** Holds if this comparison is strict, i.e. `<` or `>`. */
  predicate isStrict() { this instanceof LTExpr or this instanceof GTExpr }
}

/**
 * A greater-than operation, for example `x > y`.
 */
class GTExpr extends RelationalOperation, @gt_expr {
  override string getOperator() { result = ">" }

  override Expr getGreaterOperand() { result = getLeftOperand() }

  override Expr getLesserOperand() { result = getRightOperand() }

  override string getAPrimaryQlClass() { result = "GTExpr" }
}

/**
 * A less-than operation, for example `x < y`.
 */
class LTExpr extends RelationalOperation, @lt_expr {
  override string getOperator() { result = "<" }

  override Expr getGreaterOperand() { result = getRightOperand() }

  override Expr getLesserOperand() { result = getLeftOperand() }

  override string getAPrimaryQlClass() { result = "LTExpr" }
}

/**
 * A greater-than or equals operation, for example `x >= y`.
 */
class GEExpr extends RelationalOperation, @ge_expr {
  override string getOperator() { result = ">=" }

  override Expr getGreaterOperand() { result = getLeftOperand() }

  override Expr getLesserOperand() { result = getRightOperand() }

  override string getAPrimaryQlClass() { result = "GEExpr" }
}

/**
 * A less-than or equals operation, for example `x <= y`.
 */
class LEExpr extends RelationalOperation, @le_expr {
  override string getOperator() { result = "<=" }

  override Expr getGreaterOperand() { result = getRightOperand() }

  override Expr getLesserOperand() { result = getLeftOperand() }

  override string getAPrimaryQlClass() { result = "LEExpr" }
}
