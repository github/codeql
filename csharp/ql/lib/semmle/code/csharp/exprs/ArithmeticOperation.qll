/**
 * Provides all arithmetic operation classes.
 *
 * All arithmetic operations have the common base class `ArithmeticOperation`.
 */

import Expr

/**
 * An arithmetic operation. Either a unary arithmetic operation
 * (`UnaryArithmeticOperation`) or a binary arithmetic operation
 * (`BinaryArithmeticOperation`).
 */
class ArithmeticOperation extends Operation, @arith_op_expr {
  override string getOperator() { none() }
}

/**
 * A unary arithmetic operation. Either a unary minus operation
 * (`UnaryMinusExpr`), a unary plus operation (`UnaryPlusExpr`),
 * or a mutator operation (`MutatorOperation`).
 */
class UnaryArithmeticOperation extends ArithmeticOperation, UnaryOperation, @un_arith_op_expr { }

/**
 * A unary minus operation, for example `-x`.
 */
class UnaryMinusExpr extends UnaryArithmeticOperation, @minus_expr {
  override string getOperator() { result = "-" }

  override string getAPrimaryQlClass() { result = "UnaryMinusExpr" }
}

/**
 * A unary plus operation, for example `+x`.
 */
class UnaryPlusExpr extends UnaryArithmeticOperation, @plus_expr {
  override string getOperator() { result = "+" }

  override string getAPrimaryQlClass() { result = "UnaryPlusExpr" }
}

/**
 * A mutator operation. Either an increment operation (`IncrementOperation`)
 * or a decrement operation (`DecrementOperation`).
 */
class MutatorOperation extends UnaryArithmeticOperation, @mut_op_expr { }

/**
 * An increment operation. Either a postfix increment operation
 * (`PostIncrExpr`) or a prefix increment operation (`PreIncrExpr`).
 */
class IncrementOperation extends MutatorOperation, @incr_op_expr {
  override string getOperator() { result = "++" }
}

/**
 * A decrement operation. Either a postfix decrement operation
 * (`PostDecrExpr`) or a prefix decrement operation (`PreDecrExpr`).
 */
class DecrementOperation extends MutatorOperation, @decr_op_expr {
  override string getOperator() { result = "--" }
}

/**
 * A prefix increment operation, for example `++x`.
 */
class PreIncrExpr extends IncrementOperation, @pre_incr_expr {
  override string getAPrimaryQlClass() { result = "PreIncrExpr" }
}

/**
 * A prefix decrement operation, for example `--x`.
 */
class PreDecrExpr extends DecrementOperation, @pre_decr_expr {
  override string getAPrimaryQlClass() { result = "PreDecrExpr" }
}

/**
 * A postfix increment operation, for example `x++`.
 */
class PostIncrExpr extends IncrementOperation, @post_incr_expr {
  override string toString() { result = "..." + this.getOperator() }

  override string getAPrimaryQlClass() { result = "PostIncrExpr" }
}

/**
 * A postfix decrement operation, for example `x--`.
 */
class PostDecrExpr extends DecrementOperation, @post_decr_expr {
  override string toString() { result = "..." + this.getOperator() }

  override string getAPrimaryQlClass() { result = "PostDecrExpr" }
}

/**
 * A binary arithmetic operation. Either an addition operation
 * (`AddExpr`), a subtraction operation (`SubExpr`), a multiplication
 * operation (`MulExpr`), a division operation (`DivExpr`), or a
 * remainder operation (`RemExpr`).
 */
class BinaryArithmeticOperation extends ArithmeticOperation, BinaryOperation, @bin_arith_op_expr {
  override string getOperator() { none() }
}

/**
 * An addition operation, for example `x + y`.
 */
class AddExpr extends BinaryArithmeticOperation, @add_expr {
  override string getOperator() { result = "+" }

  override string getAPrimaryQlClass() { result = "AddExpr" }
}

/**
 * A subtraction operation, for example `x - y`.
 */
class SubExpr extends BinaryArithmeticOperation, @sub_expr {
  override string getOperator() { result = "-" }

  override string getAPrimaryQlClass() { result = "SubExpr" }
}

/**
 * A multiplication operation, for example `x * y`.
 */
class MulExpr extends BinaryArithmeticOperation, @mul_expr {
  override string getOperator() { result = "*" }

  override string getAPrimaryQlClass() { result = "MulExpr" }
}

/**
 * A division operation, for example `x / y`.
 */
class DivExpr extends BinaryArithmeticOperation, @div_expr {
  override string getOperator() { result = "/" }

  /** Gets the numerator of this division operation. */
  Expr getNumerator() { result = this.getLeftOperand() }

  /** Gets the denominator of this division operation. */
  Expr getDenominator() { result = this.getRightOperand() }

  override string getAPrimaryQlClass() { result = "DivExpr" }
}

/**
 * A remainder operation, for example `x % y`.
 */
class RemExpr extends BinaryArithmeticOperation, @rem_expr {
  override string getOperator() { result = "%" }

  override string getAPrimaryQlClass() { result = "RemExpr" }
}
