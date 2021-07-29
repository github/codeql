private import codeql_ruby.AST
private import internal.AST
private import internal.TreeSitter
private import internal.Operation

/**
 * An operation.
 *
 * This is the QL root class for all operations.
 */
class Operation extends Expr, TOperation {
  /** Gets the operator of this operation. */
  string getOperator() { none() }

  /** Gets an operand of this operation. */
  Expr getAnOperand() { none() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getAnOperand" and result = this.getAnOperand()
  }
}

/** A unary operation. */
class UnaryOperation extends Operation, TUnaryOperation {
  /** Gets the operand of this unary operation. */
  Expr getOperand() { none() }

  final override Expr getAnOperand() { result = this.getOperand() }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getOperand" and result = this.getOperand()
  }

  final override string toString() { result = this.getOperator() + " ..." }
}

private class UnaryOperationGenerated extends UnaryOperation, TUnaryOperation {
  private Ruby::Unary g;

  UnaryOperationGenerated() { g = toGenerated(this) }

  final override Expr getOperand() { toGenerated(result) = g.getOperand() }

  final override string getOperator() { result = g.getOperator() }
}

/** A unary logical operation. */
class UnaryLogicalOperation extends UnaryOperationGenerated, TUnaryLogicalOperation { }

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
class UnaryArithmeticOperation extends UnaryOperationGenerated, TUnaryArithmeticOperation { }

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
  final override Expr getOperand() { result = this.(SplatExprImpl).getOperandImpl() }

  final override string getOperator() { result = "*" }

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

  final override Expr getOperand() { toGenerated(result) = g.getChild() }

  final override string getOperator() { result = "**" }

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
class BinaryOperation extends Operation, TBinaryOperation {
  final override Expr getAnOperand() {
    result = this.getLeftOperand() or result = this.getRightOperand()
  }

  final override string toString() { result = "... " + this.getOperator() + " ..." }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getLeftOperand" and result = this.getLeftOperand()
    or
    pred = "getRightOperand" and result = this.getRightOperand()
  }

  /** Gets the left operand of this binary operation. */
  Stmt getLeftOperand() { none() }

  /** Gets the right operand of this binary operation. */
  Stmt getRightOperand() { none() }
}

private class BinaryOperationReal extends BinaryOperation {
  private Ruby::Binary g;

  BinaryOperationReal() { g = toGenerated(this) }

  final override string getOperator() { result = g.getOperator() }

  final override Stmt getLeftOperand() { toGenerated(result) = g.getLeft() }

  final override Stmt getRightOperand() { toGenerated(result) = g.getRight() }
}

abstract private class BinaryOperationSynth extends BinaryOperation {
  final override Stmt getLeftOperand() { synthChild(this, 0, result) }

  final override Stmt getRightOperand() { synthChild(this, 1, result) }
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

private class AddExprSynth extends AddExpr, BinaryOperationSynth, TAddExprSynth {
  final override string getOperator() { result = "+" }
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

private class SubExprSynth extends SubExpr, BinaryOperationSynth, TSubExprSynth {
  final override string getOperator() { result = "-" }
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

private class MulExprSynth extends MulExpr, BinaryOperationSynth, TMulExprSynth {
  final override string getOperator() { result = "*" }
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

private class DivExprSynth extends DivExpr, BinaryOperationSynth, TDivExprSynth {
  final override string getOperator() { result = "/" }
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

private class ModuloExprSynth extends ModuloExpr, BinaryOperationSynth, TModuloExprSynth {
  final override string getOperator() { result = "%" }
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

private class ExponentExprSynth extends ExponentExpr, BinaryOperationSynth, TExponentExprSynth {
  final override string getOperator() { result = "**" }
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

private class LogicalAndExprSynth extends LogicalAndExpr, BinaryOperationSynth, TLogicalAndExprSynth {
  final override string getOperator() { result = "&&" }
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

private class LogicalOrExprSynth extends LogicalOrExpr, BinaryOperationSynth, TLogicalOrExprSynth {
  final override string getOperator() { result = "||" }
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

private class LShiftExprSynth extends LShiftExpr, BinaryOperationSynth, TLShiftExprSynth {
  final override string getOperator() { result = "<<" }
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

private class RShiftExprSynth extends RShiftExpr, BinaryOperationSynth, TRShiftExprSynth {
  final override string getOperator() { result = ">>" }
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

private class BitwiseAndSynthExpr extends BitwiseAndExpr, BinaryOperationSynth, TBitwiseAndExprSynth {
  final override string getOperator() { result = "&" }
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

private class BitwiseOrSynthExpr extends BitwiseOrExpr, BinaryOperationSynth, TBitwiseOrExprSynth {
  final override string getOperator() { result = "|" }
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

private class BitwiseXorSynthExpr extends BitwiseXorExpr, BinaryOperationSynth, TBitwiseXorExprSynth {
  final override string getOperator() { result = "^" }
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
class Assignment extends Operation, TAssignment {
  /** Gets the left hand side of this assignment. */
  final Pattern getLeftOperand() { result = this.(AssignmentImpl).getLeftOperandImpl() }

  /** Gets the right hand side of this assignment. */
  final Expr getRightOperand() { result = this.(AssignmentImpl).getRightOperandImpl() }

  final override Expr getAnOperand() {
    result = this.getLeftOperand() or result = this.getRightOperand()
  }

  final override string toString() { result = "... " + this.getOperator() + " ..." }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getLeftOperand" and result = getLeftOperand()
    or
    pred = "getRightOperand" and result = getRightOperand()
  }
}

/**
 * An assignment operation with the operator `=`.
 * ```rb
 * x = 123
 * ```
 */
class AssignExpr extends Assignment, TAssignExpr {
  final override string getOperator() { result = "=" }

  final override string getAPrimaryQlClass() { result = "AssignExpr" }
}

/**
 * A binary assignment operation other than `=`.
 */
class AssignOperation extends Assignment, TAssignOperation {
  Ruby::OperatorAssignment g;

  AssignOperation() { g = toGenerated(this) }

  final override string getOperator() { result = g.getOperator() }
}

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
