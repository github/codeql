/**
 * Provides classes for bitwise operations.
 */

private import codeql.rust.elements.BinaryExpr
private import codeql.rust.elements.Operation
private import codeql.rust.elements.AssignmentOperation

/**
 * A bitwise operation, such as `&`, `<<`, or `|=`.
 */
abstract private class BitwiseOperationImpl extends Operation { }

final class BitwiseOperation = BitwiseOperationImpl;

/**
 * A binary bitwise operation, such as `&` or `<<`.
 */
final class BinaryBitwiseOperation extends BinaryExpr, BitwiseOperationImpl {
  BinaryBitwiseOperation() { this.getOperatorName() = ["&", "|", "^", "<<", ">>"] }
}

/**
 * A bitwise assignment operation, such as `|=` or `<<=`.
 */
final class AssignBitwiseOperation extends BinaryExpr, BitwiseOperationImpl, AssignmentOperation {
  AssignBitwiseOperation() { this.getOperatorName() = ["&=", "|=", "^=", "<<=", ">>="] }
}
