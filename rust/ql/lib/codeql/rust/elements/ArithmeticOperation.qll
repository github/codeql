/**
 * Provides classes for arithmetic operations.
 */

private import codeql.rust.elements.BinaryExpr
private import codeql.rust.elements.PrefixExpr
private import codeql.rust.elements.Operation
private import codeql.rust.elements.AssignmentOperation

/**
 * An arithmetic operation, such as `+`, `*=`, or `-`.
 */
abstract private class ArithmeticOperationImpl extends Operation { }

final class ArithmeticOperation = ArithmeticOperationImpl;

/**
 * A binary arithmetic operation, such as `+` or `*`.
 */
final class BinaryArithmeticOperation extends BinaryExpr, ArithmeticOperationImpl {
  BinaryArithmeticOperation() { this.getOperatorName() = ["+", "-", "*", "/", "%"] }
}

/**
 * An arithmetic assignment operation, such as `+=` or `*=`.
 */
final class AssignArithmeticOperation extends BinaryExpr, ArithmeticOperationImpl,
  AssignmentOperation
{
  AssignArithmeticOperation() { this.getOperatorName() = ["+=", "-=", "*=", "/=", "%="] }
}

/**
 * A prefix arithmetic operation, such as `-`.
 */
final class PrefixArithmeticOperation extends PrefixExpr, ArithmeticOperationImpl {
  PrefixArithmeticOperation() { this.getOperatorName() = "-" }
}
