private import codeql_ruby.AST
private import internal.Operation

/**
 * An operation.
 *
 * This is the QL root class for all operations.
 */
class Operation extends Expr {
  override Operation::Range range;

  /** Gets the operator of this operation. */
  final string getOperator() { result = range.getOperator() }

  /** Gets an operand of this operation. */
  final Expr getAnOperand() { result = range.getAnOperand() }
}

/** A unary operation. */
class UnaryOperation extends Operation, @unary {
  override UnaryOperation::Range range;

  /** Gets the operand of this unary operation. */
  final Expr getOperand() { result = range.getOperand() }
}

/** A unary logical operation. */
class UnaryLogicalOperation extends UnaryOperation {
  override UnaryLogicalOperation::Range range;
}

/**
 * A logical NOT operation, using either `!` or `not`.
 * ```rb
 * !x.nil?
 * not params.empty?
 * ```
 */
class NotExpr extends UnaryLogicalOperation, NotExpr::DbUnion {
  final override NotExpr::Range range;

  final override string getAPrimaryQlClass() { result = "NotExpr" }
}

/** A unary arithmetic operation. */
class UnaryArithmeticOperation extends UnaryOperation {
  override UnaryArithmeticOperation::Range range;
}

/**
 * A unary plus expression.
 * ```rb
 * + a
 * ```
 */
class UnaryPlusExpr extends UnaryArithmeticOperation, @unary_plus {
  final override UnaryPlusExpr::Range range;

  final override string getAPrimaryQlClass() { result = "UnaryPlusExpr" }
}

/**
 * A unary minus expression.
 * ```rb
 * - a
 * ```
 */
class UnaryMinusExpr extends UnaryArithmeticOperation, @unary_minus {
  final override UnaryMinusExpr::Range range;

  final override string getAPrimaryQlClass() { result = "UnaryMinusExpr" }
}

/** A unary bitwise operation. */
class UnaryBitwiseOperation extends UnaryOperation {
  override UnaryBitwiseOperation::Range range;
}

/**
 * A complement (bitwise NOT) expression.
 * ```rb
 * ~x
 * ```
 */
class ComplementExpr extends UnaryBitwiseOperation, @unary_tilde {
  final override ComplementExpr::Range range;

  final override string getAPrimaryQlClass() { result = "ComplementExpr" }
}

/**
 * A call to the special `defined?` operator.
 * ```rb
 * defined? some_method
 * ```
 */
class DefinedExpr extends UnaryOperation, @unary_definedquestion {
  final override DefinedExpr::Range range;

  final override string getAPrimaryQlClass() { result = "DefinedExpr" }
}

/** A binary operation. */
class BinaryOperation extends Operation, @binary {
  override BinaryOperation::Range range;

  /** Gets the left operand of this binary operation. */
  final Stmt getLeftOperand() { result = range.getLeftOperand() }

  /** Gets the right operand of this binary operation. */
  final Stmt getRightOperand() { result = range.getRightOperand() }
}

/**
 * A binary arithmetic operation.
 */
class BinaryArithmeticOperation extends BinaryOperation {
  override BinaryArithmeticOperation::Range range;
}

/**
 * An add expression.
 * ```rb
 * x + 1
 * ```
 */
class AddExpr extends BinaryArithmeticOperation, @binary_plus {
  final override AddExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AddExpr" }
}

/**
 * A subtract expression.
 * ```rb
 * x - 3
 * ```
 */
class SubExpr extends BinaryArithmeticOperation, @binary_minus {
  final override SubExpr::Range range;

  final override string getAPrimaryQlClass() { result = "SubExpr" }
}

/**
 * A multiply expression.
 * ```rb
 * x * 10
 * ```
 */
class MulExpr extends BinaryArithmeticOperation, @binary_star {
  final override MulExpr::Range range;

  final override string getAPrimaryQlClass() { result = "MulExpr" }
}

/**
 * A divide expression.
 * ```rb
 * x / y
 * ```
 */
class DivExpr extends BinaryArithmeticOperation, @binary_slash {
  final override DivExpr::Range range;

  final override string getAPrimaryQlClass() { result = "DivExpr" }
}

/**
 * A modulo expression.
 * ```rb
 * x % 2
 * ```
 */
class ModuloExpr extends BinaryArithmeticOperation, @binary_percent {
  final override ModuloExpr::Range range;

  final override string getAPrimaryQlClass() { result = "ModuloExpr" }
}

/**
 * An exponent expression.
 * ```rb
 * x ** 2
 * ```
 */
class ExponentExpr extends BinaryArithmeticOperation, @binary_starstar {
  final override ExponentExpr::Range range;

  final override string getAPrimaryQlClass() { result = "ExponentExpr" }
}

/**
 * A binary logical operation.
 */
class BinaryLogicalOperation extends BinaryOperation {
  override BinaryLogicalOperation::Range range;
}

/**
 * A logical AND operation, using either `and` or `&&`.
 * ```rb
 * x and y
 * a && b
 * ```
 */
class LogicalAndExpr extends BinaryLogicalOperation, LogicalAndExpr::DbUnion {
  final override LogicalAndExpr::Range range;

  final override string getAPrimaryQlClass() { result = "LogicalAndExpr" }
}

/**
 * A logical OR operation, using either `or` or `||`.
 * ```rb
 * x or y
 * a || b
 * ```
 */
class LogicalOrExpr extends BinaryLogicalOperation, LogicalOrExpr::DbUnion {
  final override LogicalOrExpr::Range range;

  final override string getAPrimaryQlClass() { result = "LogicalOrExpr" }
}

/**
 * A binary bitwise operation.
 */
class BinaryBitwiseOperation extends BinaryOperation {
  override BinaryBitwiseOperation::Range range;
}

/**
 * A left-shift operation.
 * ```rb
 * x << n
 * ```
 */
class LShiftExpr extends BinaryBitwiseOperation, @binary_langlelangle {
  final override LShiftExpr::Range range;

  final override string getAPrimaryQlClass() { result = "LShiftExpr" }
}

/**
 * A right-shift operation.
 * ```rb
 * x >> n
 * ```
 */
class RShiftExpr extends BinaryBitwiseOperation, @binary_ranglerangle {
  final override RShiftExpr::Range range;

  final override string getAPrimaryQlClass() { result = "RShiftExpr" }
}

/**
 * A bitwise AND operation.
 * ```rb
 * x & 0xff
 * ```
 */
class BitwiseAndExpr extends BinaryBitwiseOperation, @binary_ampersand {
  final override BitwiseAndExpr::Range range;

  final override string getAPrimaryQlClass() { result = "BitwiseAndExpr" }
}

/**
 * A bitwise OR operation.
 * ```rb
 * x | 0x01
 * ```
 */
class BitwiseOrExpr extends BinaryBitwiseOperation, @binary_pipe {
  final override BitwiseOrExpr::Range range;

  final override string getAPrimaryQlClass() { result = "BitwiseOrExpr" }
}

/**
 * An XOR (exclusive OR) operation.
 * ```rb
 * x ^ y
 * ```
 */
class BitwiseXorExpr extends BinaryBitwiseOperation, @binary_caret {
  final override BitwiseXorExpr::Range range;

  final override string getAPrimaryQlClass() { result = "BitwiseXorExpr" }
}

/**
 * A comparison operation. That is, either an equality operation or a
 * relational operation.
 */
class ComparisonOperation extends BinaryOperation {
  override ComparisonOperation::Range range;
}

/**
 * An equality operation.
 */
class EqualityOperation extends ComparisonOperation {
  override EqualityOperation::Range range;
}

/**
 * An equals expression.
 * ```rb
 * x == y
 * ```
 */
class EqExpr extends EqualityOperation, @binary_equalequal {
  final override EqExpr::Range range;

  final override string getAPrimaryQlClass() { result = "EqExpr" }
}

/**
 * A not-equals expression.
 * ```rb
 * x != y
 * ```
 */
class NEExpr extends EqualityOperation, @binary_bangequal {
  final override NEExpr::Range range;

  final override string getAPrimaryQlClass() { result = "NEExpr" }
}

/**
 * A case-equality (or 'threequals') expression.
 * ```rb
 * String === "foo"
 * ```
 */
class CaseEqExpr extends EqualityOperation, @binary_equalequalequal {
  final override CaseEqExpr::Range range;

  final override string getAPrimaryQlClass() { result = "CaseEqExpr" }
}

/**
 * A relational operation, that is, one of `<=`, `<`, `>`, or `>=`.
 */
class RelationalOperation extends ComparisonOperation {
  override RelationalOperation::Range range;

  final Expr getGreaterOperand() { result = range.getGreaterOperand() }

  final Expr getLesserOperand() { result = range.getLesserOperand() }
}

/**
 * A greater-than expression.
 * ```rb
 * x > 0
 * ```
 */
class GTExpr extends RelationalOperation, @binary_rangle {
  final override GTExpr::Range range;

  final override string getAPrimaryQlClass() { result = "GTExpr" }
}

/**
 * A greater-than-or-equal expression.
 * ```rb
 * x >= 0
 * ```
 */
class GEExpr extends RelationalOperation, @binary_rangleequal {
  final override GEExpr::Range range;

  final override string getAPrimaryQlClass() { result = "GEExpr" }
}

/**
 * A less-than expression.
 * ```rb
 * x < 10
 * ```
 */
class LTExpr extends RelationalOperation, @binary_langle {
  final override LTExpr::Range range;

  final override string getAPrimaryQlClass() { result = "LTExpr" }
}

/**
 * A less-than-or-equal expression.
 * ```rb
 * x <= 10
 * ```
 */
class LEExpr extends RelationalOperation, @binary_langleequal {
  final override LEExpr::Range range;

  final override string getAPrimaryQlClass() { result = "LEExpr" }
}

/**
 * A three-way comparison ('spaceship') expression.
 * ```rb
 * a <=> b
 * ```
 */
class SpaceshipExpr extends BinaryOperation, @binary_langleequalrangle {
  final override SpaceshipExpr::Range range;

  final override string getAPrimaryQlClass() { result = "SpaceshipExpr" }
}

/**
 * A regex match expression.
 * ```rb
 * input =~ /\d/
 * ```
 */
class RegexMatchExpr extends BinaryOperation, @binary_equaltilde {
  final override RegexMatchExpr::Range range;

  final override string getAPrimaryQlClass() { result = "RegexMatchExpr" }
}

/**
 * A regex-doesn't-match expression.
 * ```rb
 * input !~ /\d/
 * ```
 */
class NoRegexMatchExpr extends BinaryOperation, @binary_bangtilde {
  final override NoRegexMatchExpr::Range range;

  final override string getAPrimaryQlClass() { result = "NoRegexMatchExpr" }
}

/**
 * A binary assignment operation, including `=`, `+=`, `&=`, etc.
 *
 * This is a QL base class for all assignments.
 */
class Assignment extends Operation {
  override Assignment::Range range;

  /** Gets the left hand side of this assignment. */
  Pattern getLeftOperand() { result = range.getLeftOperand() }

  /** Gets the right hand side of this assignment. */
  final Expr getRightOperand() { result = range.getRightOperand() }
}

/**
 * An assignment operation with the operator `=`.
 * ```rb
 * x = 123
 * ```
 */
class AssignExpr extends Assignment {
  override AssignExpr::Range range;

  override string getAPrimaryQlClass() { result = "AssignExpr" }
}

/**
 * A binary assignment operation other than `=`.
 */
class AssignOperation extends Assignment {
  override AssignOperation::Range range;
}

/**
 * An arithmetic assignment operation: `+=`, `-=`, `*=`, `/=`, `**=`, and `%=`.
 */
class AssignArithmeticOperation extends AssignOperation {
  override AssignArithmeticOperation::Range range;
}

/**
 * A `+=` assignment expression.
 * ```rb
 * x += 1
 * ```
 */
class AssignAddExpr extends AssignArithmeticOperation, @operator_assignment_plusequal {
  final override AssignAddExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignAddExpr" }
}

/**
 * A `-=` assignment expression.
 * ```rb
 * x -= 3
 * ```
 */
class AssignSubExpr extends AssignArithmeticOperation, @operator_assignment_minusequal {
  final override AssignSubExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignSubExpr" }
}

/**
 * A `*=` assignment expression.
 * ```rb
 * x *= 10
 * ```
 */
class AssignMulExpr extends AssignArithmeticOperation, @operator_assignment_starequal {
  final override AssignMulExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignMulExpr" }
}

/**
 * A `/=` assignment expression.
 * ```rb
 * x /= y
 * ```
 */
class AssignDivExpr extends AssignArithmeticOperation, @operator_assignment_slashequal {
  final override AssignDivExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignDivExpr" }
}

/**
 * A `%=` assignment expression.
 * ```rb
 * x %= 4
 * ```
 */
class AssignModuloExpr extends AssignArithmeticOperation, @operator_assignment_percentequal {
  final override AssignModuloExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignModuloExpr" }
}

/**
 * A `**=` assignment expression.
 * ```rb
 * x **= 2
 * ```
 */
class AssignExponentExpr extends AssignArithmeticOperation, @operator_assignment_starstarequal {
  final override AssignExponentExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignExponentExpr" }
}

/**
 * A logical assignment operation: `&&=` and `||=`.
 */
class AssignLogicalOperation extends AssignOperation {
  override AssignLogicalOperation::Range range;

  final override LhsExpr getLeftOperand() { result = super.getLeftOperand() }
}

/**
 * A logical AND assignment operation.
 * ```rb
 * x &&= y.even?
 * ```
 */
class AssignLogicalAndExpr extends AssignLogicalOperation,
  @operator_assignment_ampersandampersandequal {
  final override AssignLogicalAndExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignLogicalAndExpr" }
}

/**
 * A logical OR assignment operation.
 * ```rb
 * x ||= y
 * ```
 */
class AssignLogicalOrExpr extends AssignLogicalOperation, @operator_assignment_pipepipeequal {
  final override AssignLogicalOrExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignLogicalOrExpr" }
}

/**
 * A bitwise assignment operation: `<<=`, `>>=`, `&=`, `|=` and `^=`.
 */
class AssignBitwiseOperation extends AssignOperation {
  override AssignBitwiseOperation::Range range;
}

/**
 * A left-shift assignment operation.
 * ```rb
 * x <<= 3
 * ```
 */
class AssignLShiftExpr extends AssignBitwiseOperation, @operator_assignment_langlelangleequal {
  final override AssignLShiftExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignLShiftExpr" }
}

/**
 * A right-shift assignment operation.
 * ```rb
 * x >>= 3
 * ```
 */
class AssignRShiftExpr extends AssignBitwiseOperation, @operator_assignment_ranglerangleequal {
  final override AssignRShiftExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignRShiftExpr" }
}

/**
 * A bitwise AND assignment operation.
 * ```rb
 * x &= 0xff
 * ```
 */
class AssignBitwiseAndExpr extends AssignBitwiseOperation, @operator_assignment_ampersandequal {
  final override AssignBitwiseAndExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignBitwiseAndExpr" }
}

/**
 * A bitwise OR assignment operation.
 * ```rb
 * x |= 0x01
 * ```
 */
class AssignBitwiseOrExpr extends AssignBitwiseOperation, @operator_assignment_pipeequal {
  final override AssignBitwiseOrExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignBitwiseOrExpr" }
}

/**
 * An XOR (exclusive OR) assignment operation.
 * ```rb
 * x ^= y
 * ```
 */
class AssignBitwiseXorExpr extends AssignBitwiseOperation, @operator_assignment_caretequal {
  final override AssignBitwiseXorExpr::Range range;

  final override string getAPrimaryQlClass() { result = "AssignBitwiseXorExpr" }
}
