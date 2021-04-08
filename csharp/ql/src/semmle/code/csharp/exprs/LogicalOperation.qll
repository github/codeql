/**
 * Provides all logical operation classes.
 *
 * All logical operations have the common base class `LogicalOperation`.
 */

import Expr

/**
 * A logical operation. Either a unary logical operation (`UnaryLogicalOperation`),
 * a binary logical operation (`BinaryLogicalOperation`), or a ternary logical
 * operation (`TernaryLogicalOperation`).
 */
class LogicalOperation extends Operation, @log_expr {
  override string getOperator() { none() }
}

/**
 * A unary logical operation, that is, a logical 'not' (`LogicalNotExpr`).
 */
class UnaryLogicalOperation extends LogicalOperation, UnaryOperation, @un_log_op_expr { }

/**
 * A logical 'not', for example `!String.IsNullOrEmpty(s)`.
 */
class LogicalNotExpr extends UnaryLogicalOperation, @log_not_expr {
  override string getOperator() { result = "!" }

  override string getAPrimaryQlClass() { result = "LogicalNotExpr" }
}

/**
 * A binary logical operation. Either a logical 'and' (`LogicalAndExpr`),
 * a logical 'or' (`LogicalAndExpr`), or a null-coalescing operation
 * (`NullCoalescingExpr`).
 */
class BinaryLogicalOperation extends LogicalOperation, BinaryOperation, @bin_log_op_expr {
  override string getOperator() { none() }
}

/**
 * A logical 'and', for example `x != null && x.Length > 0`.
 */
class LogicalAndExpr extends BinaryLogicalOperation, @log_and_expr {
  override string getOperator() { result = "&&" }

  override string getAPrimaryQlClass() { result = "LogicalAndExpr" }
}

/**
 * A logical 'or', for example `x == null || x.Length == 0`.
 */
class LogicalOrExpr extends BinaryLogicalOperation, @log_or_expr {
  override string getOperator() { result = "||" }

  override string getAPrimaryQlClass() { result = "LogicalOrExpr" }
}

/**
 * A null-coalescing operation, for example `s ?? ""` on line 2 in
 *
 * ```csharp
 * string NonNullOrEmpty(string s) {
 *   return s ?? "";
 * }
 * ```
 */
class NullCoalescingExpr extends BinaryLogicalOperation, @null_coalescing_expr {
  override string getOperator() { result = "??" }

  override string getAPrimaryQlClass() { result = "NullCoalescingExpr" }
}

/**
 * A ternary logical operation, that is, a ternary conditional expression
 * (`ConditionalExpr`).
 */
class TernaryLogicalOperation extends LogicalOperation, TernaryOperation, @ternary_log_op_expr { }

/**
 * A conditional expression, for example `s != null ? s.Length : -1`
 * on line 2 in
 *
 * ```csharp
 * int LengthOrNegative(string s) {
 *   return s != null ? s.Length : -1;
 * }
 * ```
 */
class ConditionalExpr extends TernaryLogicalOperation, @conditional_expr {
  /** Gets the condition of this conditional expression. */
  Expr getCondition() { result = this.getChild(0) }

  /** Gets the "then" expression of this conditional expression. */
  Expr getThen() { result = this.getChild(1) }

  /** Gets the "else" expression of this conditional expression. */
  Expr getElse() { result = this.getChild(2) }

  override string getOperator() { result = "?" }

  override string toString() { result = "... ? ... : ..." }

  override string getAPrimaryQlClass() { result = "ConditionalExpr" }
}
