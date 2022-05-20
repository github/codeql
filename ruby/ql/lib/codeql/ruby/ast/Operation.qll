private import codeql.ruby.AST
private import internal.AST
private import internal.TreeSitter
private import internal.Operation

/**
 * An operation.
 *
 * This is the QL root class for all operations.
 */
class Operation extends Expr instanceof OperationImpl {
  /** Gets the operator of this operation. */
  final string getOperator() { result = super.getOperatorImpl() }

  /** Gets an operand of this operation. */
  final Expr getAnOperand() { result = super.getAnOperandImpl() }

  override AstNode getAChild(string pred) {
    result = Expr.super.getAChild(pred)
    or
    pred = "getAnOperand" and result = this.getAnOperand()
  }
}

/** A unary operation. */
class UnaryOperation extends Operation, MethodCall instanceof UnaryOperationImpl {
  /** Gets the operand of this unary operation. */
  final Expr getOperand() { result = super.getOperandImpl() }

  final override AstNode getAChild(string pred) {
    result = Operation.super.getAChild(pred)
    or
    result = MethodCall.super.getAChild(pred)
    or
    pred = "getOperand" and result = this.getOperand()
  }

  final override string toString() { result = this.getOperator() + " ..." }
}

/** A unary logical operation. */
class UnaryLogicalOperation extends UnaryOperation, TUnaryLogicalOperation { }

/**
 * A logical NOT operation, using either `!` or `not`.
 * ```rb
 * !x.nil?
 * not params.empty?
 * ```
 */
class NotExpr extends UnaryLogicalOperation, TNotExpr {
  final override string getAPrimaryQlClass() { result = "NotExpr" }
}

/** A unary arithmetic operation. */
class UnaryArithmeticOperation extends UnaryOperation, TUnaryArithmeticOperation { }

/**
 * A unary plus expression.
 * ```rb
 * + a
 * ```
 */
class UnaryPlusExpr extends UnaryArithmeticOperation, TUnaryPlusExpr {
  final override string getAPrimaryQlClass() { result = "UnaryPlusExpr" }
}

/**
 * A unary minus expression.
 * ```rb
 * - a
 * ```
 */
class UnaryMinusExpr extends UnaryArithmeticOperation, TUnaryMinusExpr {
  final override string getAPrimaryQlClass() { result = "UnaryMinusExpr" }
}

/**
 * A splat expression.
 * ```rb
 * foo(*args)
 * ```
 */
class SplatExpr extends UnaryOperation, TSplatExpr {
  final override string getAPrimaryQlClass() { result = "SplatExpr" }
}

/**
 * A hash-splat (or 'double-splat') expression.
 * ```rb
 * foo(**options)
 * ```
 */
class HashSplatExpr extends UnaryOperation, THashSplatExpr {
  private Ruby::HashSplatArgument g;

  HashSplatExpr() { this = THashSplatExpr(g) }

  final override string getAPrimaryQlClass() { result = "HashSplatExpr" }
}

/** A unary bitwise operation. */
class UnaryBitwiseOperation extends UnaryOperation, TUnaryBitwiseOperation { }

/**
 * A complement (bitwise NOT) expression.
 * ```rb
 * ~x
 * ```
 */
class ComplementExpr extends UnaryBitwiseOperation, TComplementExpr {
  final override string getAPrimaryQlClass() { result = "ComplementExpr" }
}

/**
 * A call to the special `defined?` operator.
 * ```rb
 * defined? some_method
 * ```
 */
class DefinedExpr extends UnaryOperation, TDefinedExpr {
  final override string getAPrimaryQlClass() { result = "DefinedExpr" }
}

/** A binary operation. */
class BinaryOperation extends Operation, MethodCall instanceof BinaryOperationImpl {
  final override string toString() { result = "... " + this.getOperator() + " ..." }

  override AstNode getAChild(string pred) {
    result = Operation.super.getAChild(pred)
    or
    result = MethodCall.super.getAChild(pred)
    or
    pred = "getLeftOperand" and result = this.getLeftOperand()
    or
    pred = "getRightOperand" and result = this.getRightOperand()
  }

  /** Gets the left operand of this binary operation. */
  final Stmt getLeftOperand() { result = super.getLeftOperandImpl() }

  /** Gets the right operand of this binary operation. */
  final Stmt getRightOperand() { result = super.getRightOperandImpl() }
}

/**
 * A binary arithmetic operation.
 */
class BinaryArithmeticOperation extends BinaryOperation, TBinaryArithmeticOperation { }

/**
 * An add expression.
 * ```rb
 * x + 1
 * ```
 */
class AddExpr extends BinaryArithmeticOperation, TAddExpr {
  final override string getAPrimaryQlClass() { result = "AddExpr" }
}

/**
 * A subtract expression.
 * ```rb
 * x - 3
 * ```
 */
class SubExpr extends BinaryArithmeticOperation, TSubExpr {
  final override string getAPrimaryQlClass() { result = "SubExpr" }
}

/**
 * A multiply expression.
 * ```rb
 * x * 10
 * ```
 */
class MulExpr extends BinaryArithmeticOperation, TMulExpr {
  final override string getAPrimaryQlClass() { result = "MulExpr" }
}

/**
 * A divide expression.
 * ```rb
 * x / y
 * ```
 */
class DivExpr extends BinaryArithmeticOperation, TDivExpr {
  final override string getAPrimaryQlClass() { result = "DivExpr" }
}

/**
 * A modulo expression.
 * ```rb
 * x % 2
 * ```
 */
class ModuloExpr extends BinaryArithmeticOperation, TModuloExpr {
  final override string getAPrimaryQlClass() { result = "ModuloExpr" }
}

/**
 * An exponent expression.
 * ```rb
 * x ** 2
 * ```
 */
class ExponentExpr extends BinaryArithmeticOperation, TExponentExpr {
  final override string getAPrimaryQlClass() { result = "ExponentExpr" }
}

/**
 * A binary logical operation.
 */
class BinaryLogicalOperation extends BinaryOperation, TBinaryLogicalOperation { }

/**
 * A logical AND operation, using either `and` or `&&`.
 * ```rb
 * x and y
 * a && b
 * ```
 */
class LogicalAndExpr extends BinaryLogicalOperation, TLogicalAndExpr {
  final override string getAPrimaryQlClass() { result = "LogicalAndExpr" }
}

/**
 * A logical OR operation, using either `or` or `||`.
 * ```rb
 * x or y
 * a || b
 * ```
 */
class LogicalOrExpr extends BinaryLogicalOperation, TLogicalOrExpr {
  final override string getAPrimaryQlClass() { result = "LogicalOrExpr" }
}

/**
 * A binary bitwise operation.
 */
class BinaryBitwiseOperation extends BinaryOperation, TBinaryBitwiseOperation { }

/**
 * A left-shift operation.
 * ```rb
 * x << n
 * ```
 */
class LShiftExpr extends BinaryBitwiseOperation, TLShiftExpr {
  final override string getAPrimaryQlClass() { result = "LShiftExpr" }
}

/**
 * A right-shift operation.
 * ```rb
 * x >> n
 * ```
 */
class RShiftExpr extends BinaryBitwiseOperation, TRShiftExpr {
  final override string getAPrimaryQlClass() { result = "RShiftExpr" }
}

/**
 * A bitwise AND operation.
 * ```rb
 * x & 0xff
 * ```
 */
class BitwiseAndExpr extends BinaryBitwiseOperation, TBitwiseAndExpr {
  final override string getAPrimaryQlClass() { result = "BitwiseAndExpr" }
}

/**
 * A bitwise OR operation.
 * ```rb
 * x | 0x01
 * ```
 */
class BitwiseOrExpr extends BinaryBitwiseOperation, TBitwiseOrExpr {
  final override string getAPrimaryQlClass() { result = "BitwiseOrExpr" }
}

/**
 * An XOR (exclusive OR) operation.
 * ```rb
 * x ^ y
 * ```
 */
class BitwiseXorExpr extends BinaryBitwiseOperation, TBitwiseXorExpr {
  final override string getAPrimaryQlClass() { result = "BitwiseXorExpr" }
}

/**
 * A comparison operation. That is, either an equality operation or a
 * relational operation.
 */
class ComparisonOperation extends BinaryOperation, TComparisonOperation { }

/**
 * An equality operation.
 */
class EqualityOperation extends ComparisonOperation, TEqualityOperation { }

/**
 * An equals expression.
 * ```rb
 * x == y
 * ```
 */
class EqExpr extends EqualityOperation, TEqExpr {
  final override string getAPrimaryQlClass() { result = "EqExpr" }
}

/**
 * A not-equals expression.
 * ```rb
 * x != y
 * ```
 */
class NEExpr extends EqualityOperation, TNEExpr {
  final override string getAPrimaryQlClass() { result = "NEExpr" }
}

/**
 * A case-equality (or 'threequals') expression.
 * ```rb
 * String === "foo"
 * ```
 */
class CaseEqExpr extends EqualityOperation, TCaseEqExpr {
  final override string getAPrimaryQlClass() { result = "CaseEqExpr" }
}

/**
 * A relational operation, that is, one of `<=`, `<`, `>`, or `>=`.
 */
class RelationalOperation extends ComparisonOperation, TRelationalOperation {
  /** Gets the greater operand. */
  Expr getGreaterOperand() { none() }

  /** Gets the lesser operand. */
  Expr getLesserOperand() { none() }

  /**
   * Holds if this is a comparison with `<=` or `>=`.
   */
  predicate isInclusive() { this instanceof LEExpr or this instanceof GEExpr }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getGreaterOperand" and result = this.getGreaterOperand()
    or
    pred = "getLesserOperand" and result = this.getLesserOperand()
  }
}

/**
 * A greater-than expression.
 * ```rb
 * x > 0
 * ```
 */
class GTExpr extends RelationalOperation, TGTExpr {
  final override string getAPrimaryQlClass() { result = "GTExpr" }

  final override Expr getGreaterOperand() { result = this.getLeftOperand() }

  final override Expr getLesserOperand() { result = this.getRightOperand() }
}

/**
 * A greater-than-or-equal expression.
 * ```rb
 * x >= 0
 * ```
 */
class GEExpr extends RelationalOperation, TGEExpr {
  final override string getAPrimaryQlClass() { result = "GEExpr" }

  final override Expr getGreaterOperand() { result = this.getLeftOperand() }

  final override Expr getLesserOperand() { result = this.getRightOperand() }
}

/**
 * A less-than expression.
 * ```rb
 * x < 10
 * ```
 */
class LTExpr extends RelationalOperation, TLTExpr {
  final override string getAPrimaryQlClass() { result = "LTExpr" }

  final override Expr getGreaterOperand() { result = this.getRightOperand() }

  final override Expr getLesserOperand() { result = this.getLeftOperand() }
}

/**
 * A less-than-or-equal expression.
 * ```rb
 * x <= 10
 * ```
 */
class LEExpr extends RelationalOperation, TLEExpr {
  final override string getAPrimaryQlClass() { result = "LEExpr" }

  final override Expr getGreaterOperand() { result = this.getRightOperand() }

  final override Expr getLesserOperand() { result = this.getLeftOperand() }
}

/**
 * A three-way comparison ('spaceship') expression.
 * ```rb
 * a <=> b
 * ```
 */
class SpaceshipExpr extends BinaryOperation, TSpaceshipExpr {
  final override string getAPrimaryQlClass() { result = "SpaceshipExpr" }
}

/**
 * A regexp match expression.
 * ```rb
 * input =~ /\d/
 * ```
 */
class RegExpMatchExpr extends BinaryOperation, TRegExpMatchExpr {
  final override string getAPrimaryQlClass() { result = "RegExpMatchExpr" }
}

/**
 * A regexp-doesn't-match expression.
 * ```rb
 * input !~ /\d/
 * ```
 */
class NoRegExpMatchExpr extends BinaryOperation, TNoRegExpMatchExpr {
  final override string getAPrimaryQlClass() { result = "NoRegExpMatchExpr" }
}

/**
 * A binary assignment operation, including `=`, `+=`, `&=`, etc.
 *
 * This is a QL base class for all assignments.
 */
class Assignment extends Operation instanceof AssignmentImpl {
  /** Gets the left hand side of this assignment. */
  final LhsExpr getLeftOperand() { result = super.getLeftOperandImpl() }

  /** Gets the right hand side of this assignment. */
  final Expr getRightOperand() { result = super.getRightOperandImpl() }

  final override string toString() { result = "... " + this.getOperator() + " ..." }

  final override AstNode getAChild(string pred) {
    result = Operation.super.getAChild(pred)
    or
    pred = "getLeftOperand" and result = this.getLeftOperand()
    or
    pred = "getRightOperand" and result = this.getRightOperand()
  }
}

/**
 * An assignment operation with the operator `=`.
 * ```rb
 * x = 123
 * ```
 */
class AssignExpr extends Assignment, TAssignExpr {
  final override string getAPrimaryQlClass() { result = "AssignExpr" }
}

/**
 * A binary assignment operation other than `=`.
 */
class AssignOperation extends Assignment instanceof AssignOperationImpl { }

/**
 * An arithmetic assignment operation: `+=`, `-=`, `*=`, `/=`, `**=`, and `%=`.
 */
class AssignArithmeticOperation extends AssignOperation, TAssignArithmeticOperation { }

/**
 * A `+=` assignment expression.
 * ```rb
 * x += 1
 * ```
 */
class AssignAddExpr extends AssignArithmeticOperation, TAssignAddExpr {
  final override string getAPrimaryQlClass() { result = "AssignAddExpr" }
}

/**
 * A `-=` assignment expression.
 * ```rb
 * x -= 3
 * ```
 */
class AssignSubExpr extends AssignArithmeticOperation, TAssignSubExpr {
  final override string getAPrimaryQlClass() { result = "AssignSubExpr" }
}

/**
 * A `*=` assignment expression.
 * ```rb
 * x *= 10
 * ```
 */
class AssignMulExpr extends AssignArithmeticOperation, TAssignMulExpr {
  final override string getAPrimaryQlClass() { result = "AssignMulExpr" }
}

/**
 * A `/=` assignment expression.
 * ```rb
 * x /= y
 * ```
 */
class AssignDivExpr extends AssignArithmeticOperation, TAssignDivExpr {
  final override string getAPrimaryQlClass() { result = "AssignDivExpr" }
}

/**
 * A `%=` assignment expression.
 * ```rb
 * x %= 4
 * ```
 */
class AssignModuloExpr extends AssignArithmeticOperation, TAssignModuloExpr {
  final override string getAPrimaryQlClass() { result = "AssignModuloExpr" }
}

/**
 * A `**=` assignment expression.
 * ```rb
 * x **= 2
 * ```
 */
class AssignExponentExpr extends AssignArithmeticOperation, TAssignExponentExpr {
  final override string getAPrimaryQlClass() { result = "AssignExponentExpr" }
}

/**
 * A logical assignment operation: `&&=` and `||=`.
 */
class AssignLogicalOperation extends AssignOperation, TAssignLogicalOperation { }

/**
 * A logical AND assignment operation.
 * ```rb
 * x &&= y.even?
 * ```
 */
class AssignLogicalAndExpr extends AssignLogicalOperation, TAssignLogicalAndExpr {
  final override string getAPrimaryQlClass() { result = "AssignLogicalAndExpr" }
}

/**
 * A logical OR assignment operation.
 * ```rb
 * x ||= y
 * ```
 */
class AssignLogicalOrExpr extends AssignLogicalOperation, TAssignLogicalOrExpr {
  final override string getAPrimaryQlClass() { result = "AssignLogicalOrExpr" }
}

/**
 * A bitwise assignment operation: `<<=`, `>>=`, `&=`, `|=` and `^=`.
 */
class AssignBitwiseOperation extends AssignOperation, TAssignBitwiseOperation { }

/**
 * A left-shift assignment operation.
 * ```rb
 * x <<= 3
 * ```
 */
class AssignLShiftExpr extends AssignBitwiseOperation, TAssignLShiftExpr {
  final override string getAPrimaryQlClass() { result = "AssignLShiftExpr" }
}

/**
 * A right-shift assignment operation.
 * ```rb
 * x >>= 3
 * ```
 */
class AssignRShiftExpr extends AssignBitwiseOperation, TAssignRShiftExpr {
  final override string getAPrimaryQlClass() { result = "AssignRShiftExpr" }
}

/**
 * A bitwise AND assignment operation.
 * ```rb
 * x &= 0xff
 * ```
 */
class AssignBitwiseAndExpr extends AssignBitwiseOperation, TAssignBitwiseAndExpr {
  final override string getAPrimaryQlClass() { result = "AssignBitwiseAndExpr" }
}

/**
 * A bitwise OR assignment operation.
 * ```rb
 * x |= 0x01
 * ```
 */
class AssignBitwiseOrExpr extends AssignBitwiseOperation, TAssignBitwiseOrExpr {
  final override string getAPrimaryQlClass() { result = "AssignBitwiseOrExpr" }
}

/**
 * An XOR (exclusive OR) assignment operation.
 * ```rb
 * x ^= y
 * ```
 */
class AssignBitwiseXorExpr extends AssignBitwiseOperation, TAssignBitwiseXorExpr {
  final override string getAPrimaryQlClass() { result = "AssignBitwiseXorExpr" }
}
