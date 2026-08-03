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
class ArithmeticOperation extends Operation, @arith_operation {
  override string getOperator() { none() }
}

/**
 * A binary arithmetic operation. Either a binary arithmetic expression (`BinaryArithmeticExpr`) or
 * an arithmetic assignment expression (`AssignArithmeticExpr`).
 */
class BinaryArithmeticOperation extends ArithmeticOperation, BinaryOperation, @bin_arith_operation {
  override string getOperator() { none() }
}

/**
 * A unary arithmetic operation. Either a unary minus expression
 * (`UnaryMinusExpr`), a unary plus expression (`UnaryPlusExpr`),
 * or a mutator operation (`MutatorOperation`).
 */
class UnaryArithmeticOperation extends ArithmeticOperation, UnaryOperation, @un_arith_operation { }

/**
 * A unary minus expression, for example `-x`.
 */
class UnaryMinusExpr extends UnaryArithmeticOperation, @minus_expr {
  override string getOperator() { result = "-" }

  override string getAPrimaryQlClass() { result = "UnaryMinusExpr" }
}

/**
 * A unary plus expression, for example `+x`.
 */
class UnaryPlusExpr extends UnaryArithmeticOperation, @plus_expr {
  override string getOperator() { result = "+" }

  override string getAPrimaryQlClass() { result = "UnaryPlusExpr" }
}

/**
 * A mutator operation. Either an increment operation (`IncrementOperation`)
 * or a decrement operation (`DecrementOperation`).
 */
class MutatorOperation extends UnaryArithmeticOperation, @mut_operation { }

/**
 * An increment operation. Either a postfix increment expression
 * (`PostIncrExpr`) or a prefix increment expression (`PreIncrExpr`).
 */
class IncrementOperation extends MutatorOperation, @incr_operation {
  override string getOperator() { result = "++" }
}

/**
 * A decrement operation. Either a postfix decrement expression
 * (`PostDecrExpr`) or a prefix decrement expression (`PreDecrExpr`).
 */
class DecrementOperation extends MutatorOperation, @decr_operation {
  override string getOperator() { result = "--" }
}

/**
 * A prefix increment expression, for example `++x`.
 */
class PreIncrExpr extends IncrementOperation, @pre_incr_expr {
  override string getAPrimaryQlClass() { result = "PreIncrExpr" }
}

/**
 * A prefix decrement expression, for example `--x`.
 */
class PreDecrExpr extends DecrementOperation, @pre_decr_expr {
  override string getAPrimaryQlClass() { result = "PreDecrExpr" }
}

/**
 * A postfix increment expression, for example `x++`.
 */
class PostIncrExpr extends IncrementOperation, @post_incr_expr {
  override string toString() { result = "..." + this.getOperator() }

  override string getAPrimaryQlClass() { result = "PostIncrExpr" }
}

/**
 * A postfix decrement expression, for example `x--`.
 */
class PostDecrExpr extends DecrementOperation, @post_decr_expr {
  override string toString() { result = "..." + this.getOperator() }

  override string getAPrimaryQlClass() { result = "PostDecrExpr" }
}

/**
 * An addition operation, either `x + y` or `x += y`.
 */
class AddOperation extends BinaryArithmeticOperation, @add_operation { }

/**
 * A subtraction operation, either `x - y` or `x -= y`.
 */
class SubOperation extends BinaryArithmeticOperation, @sub_operation { }

/**
 * A multiplication operation, either `x * y` or `x *= y`.
 */
class MulOperation extends BinaryArithmeticOperation, @mul_operation { }

/**
 * A division operation, either `x / y` or `x /= y`.
 */
class DivOperation extends BinaryArithmeticOperation, @div_operation {
  /** Gets the numerator of this division operation. */
  Expr getNumerator() { result = this.getLeftOperand() }

  /** Gets the denominator of this division operation. */
  Expr getDenominator() { result = this.getRightOperand() }
}

/**
 * A remainder operation, either `x % y` or `x %= y`.
 */
class RemOperation extends BinaryArithmeticOperation, @rem_operation { }

/**
 * A binary arithmetic expression. Either an addition expression
 * (`AddExpr`), a subtraction expression (`SubExpr`), a multiplication
 * expression (`MulExpr`), a division expression (`DivExpr`), or a
 * remainder expression (`RemExpr`).
 */
class BinaryArithmeticExpr extends BinaryArithmeticOperation, @bin_arith_expr { }

/**
 * An addition expression, for example `x + y`.
 */
class AddExpr extends BinaryArithmeticExpr, AddOperation, @add_expr {
  override string getOperator() { result = "+" }

  override string getAPrimaryQlClass() { result = "AddExpr" }
}

/**
 * A subtraction expression, for example `x - y`.
 */
class SubExpr extends BinaryArithmeticExpr, SubOperation, @sub_expr {
  override string getOperator() { result = "-" }

  override string getAPrimaryQlClass() { result = "SubExpr" }
}

/**
 * A multiplication expression, for example `x * y`.
 */
class MulExpr extends BinaryArithmeticExpr, MulOperation, @mul_expr {
  override string getOperator() { result = "*" }

  override string getAPrimaryQlClass() { result = "MulExpr" }
}

/**
 * A division expression, for example `x / y`.
 */
class DivExpr extends BinaryArithmeticExpr, DivOperation, @div_expr {
  override string getOperator() { result = "/" }

  override string getAPrimaryQlClass() { result = "DivExpr" }
}

/**
 * A remainder expression, for example `x % y`.
 */
class RemExpr extends BinaryArithmeticExpr, RemOperation, @rem_expr {
  override string getOperator() { result = "%" }

  override string getAPrimaryQlClass() { result = "RemExpr" }
}
