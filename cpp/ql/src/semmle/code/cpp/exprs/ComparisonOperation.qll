/**
 * Provides classes for modeling comparisons such as `==`, `!=` and `<`.
 */

import semmle.code.cpp.exprs.Expr

/**
 * A C/C++ comparison operation, that is, either an equality operation or a relational operation.
 *
 * This is a QL base class for all comparisons.
 */
class ComparisonOperation extends BinaryOperation, @cmp_op_expr { }

/**
 * A C/C++ equality operation, that is, either "==" or "!=".
 */
class EqualityOperation extends ComparisonOperation, @eq_op_expr {
  override int getPrecedence() { result = 9 }
}

/**
 * A C/C++ equal expression.
 * ```
 * bool c = (a == b);
 * ```
 */
class EQExpr extends EqualityOperation, @eqexpr {
  override string getAPrimaryQlClass() { result = "EQExpr" }

  override string getOperator() { result = "==" }
}

/**
 * A C/C++ not equal expression.
 * ```
 * bool c = (a != b);
 * ```
 */
class NEExpr extends EqualityOperation, @neexpr {
  override string getAPrimaryQlClass() { result = "NEExpr" }

  override string getOperator() { result = "!=" }
}

/**
 * A C/C++ relational operation, that is, one of `<=`, `<`, `>`, or `>=`.
 */
class RelationalOperation extends ComparisonOperation, @rel_op_expr {
  override int getPrecedence() { result = 10 }

  /**
   * DEPRECATED: Use `getGreaterOperand()` instead.
   */
  deprecated Expr getLarge() { result = getGreaterOperand() }

  /**
   * DEPRECATED: Use `getLesserOperand()` instead.
   */
  deprecated Expr getSmall() { result = getLesserOperand() }

  /**
   * Gets the operand on the "greater" (or "greater-or-equal") side
   * of this relational expression, that is, the side that is larger
   * if the overall expression evaluates to `true`; for example on
   * `x <= 20` this is the `20`, and on `y > 0` it is `y`.
   */
  abstract Expr getGreaterOperand();

  /**
   * Gets the operand on the "lesser" (or "lesser-or-equal") side
   * of this relational expression, that is, the side that is smaller
   * if the overall expression evaluates to `true`; for example on
   * `x <= 20` this is `x`, and on `y > 0` it is the `0`.
   */
  abstract Expr getLesserOperand();
}

/**
 * A C/C++ greater than expression.
 * ```
 * bool c = (a > b);
 * ```
 */
class GTExpr extends RelationalOperation, @gtexpr {
  override string getAPrimaryQlClass() { result = "GTExpr" }

  override string getOperator() { result = ">" }

  override Expr getGreaterOperand() { result = getLeftOperand() }

  override Expr getLesserOperand() { result = getRightOperand() }
}

/**
 * A C/C++ less than expression.
 * ```
 * bool c = (a < b);
 * ```
 */
class LTExpr extends RelationalOperation, @ltexpr {
  override string getAPrimaryQlClass() { result = "LTExpr" }

  override string getOperator() { result = "<" }

  override Expr getGreaterOperand() { result = getRightOperand() }

  override Expr getLesserOperand() { result = getLeftOperand() }
}

/**
 * A C/C++ greater than or equal expression.
 * ```
 * bool c = (a >= b);
 * ```
 */
class GEExpr extends RelationalOperation, @geexpr {
  override string getAPrimaryQlClass() { result = "GEExpr" }

  override string getOperator() { result = ">=" }

  override Expr getGreaterOperand() { result = getLeftOperand() }

  override Expr getLesserOperand() { result = getRightOperand() }
}

/**
 * A C/C++ less than or equal expression.
 * ```
 * bool c = (a <= b);
 * ```
 */
class LEExpr extends RelationalOperation, @leexpr {
  override string getAPrimaryQlClass() { result = "LEExpr" }

  override string getOperator() { result = "<=" }

  override Expr getGreaterOperand() { result = getRightOperand() }

  override Expr getLesserOperand() { result = getLeftOperand() }
}
