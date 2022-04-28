/**
 * Semantic interface for expressions.
 */

private import Semantic
private import SemanticExprSpecific::SemanticExprConfig as Specific

/**
 * An language-neutral expression.
 *
 * The expression computes a value of type `getSemType()`. The actual computation is determined by
 * the expression's opcode (`getOpcode()`).
 */
class SemExpr instanceof Specific::Expr {
  final string toString() { result = super.toString() }

  final Specific::Location getLocation() { result = super.getLocation() }

  Opcode getOpcode() { result instanceof Opcode::Unknown }

  SemType getSemType() { result = Specific::getUnknownExprType(this) }

  final SemBasicBlock getBasicBlock() { result = Specific::getExprBasicBlock(this) }
}

/** An expression with an opcode other than `Unknown`. */
abstract private class SemKnownExpr extends SemExpr {
  Opcode opcode;
  SemType type;

  final override Opcode getOpcode() { result = opcode }

  final override SemType getSemType() { result = type }
}

/** An expression that returns a literal value. */
class SemLiteralExpr extends SemKnownExpr {
  SemLiteralExpr() {
    Specific::integerLiteral(this, type, _) and opcode instanceof Opcode::Constant
    or
    Specific::largeIntegerLiteral(this, type, _) and opcode instanceof Opcode::Constant
    or
    Specific::booleanLiteral(this, type, _) and opcode instanceof Opcode::Constant
    or
    Specific::floatingPointLiteral(this, type, _) and opcode instanceof Opcode::Constant
    or
    Specific::nullLiteral(this, type) and opcode instanceof Opcode::Constant
    or
    Specific::stringLiteral(this, type, _) and opcode instanceof Opcode::StringConstant
  }
}

/** An expression that returns a numeric literal value. */
class SemNumericLiteralExpr extends SemLiteralExpr {
  SemNumericLiteralExpr() {
    Specific::integerLiteral(this, _, _)
    or
    Specific::largeIntegerLiteral(this, _, _)
    or
    Specific::floatingPointLiteral(this, _, _)
  }

  /**
   * Gets an approximation of the value of the literal, as a `float`.
   *
   * If the value can be precisely represented as a `float`, the result will be exact. If the actual
   * value cannot be precisely represented (for example, it is an integer with more than 53
   * significant bits), then the result is an approximation.
   */
  float getApproximateFloatValue() { none() }
}

/** An expression that returns an integer literal value. */
class SemIntegerLiteralExpr extends SemNumericLiteralExpr {
  SemIntegerLiteralExpr() {
    Specific::integerLiteral(this, _, _)
    or
    Specific::largeIntegerLiteral(this, _, _)
  }

  /**
   * Gets the value of the literal, if it can be represented as an `int`.
   *
   * If the value is outside the range of an `int`, use `getApproximateFloatValue()` to get a value
   * that is equal to the actual integer value, within rounding error.
   */
  final int getIntValue() { Specific::integerLiteral(this, _, result) }

  final override float getApproximateFloatValue() {
    result = getIntValue()
    or
    Specific::largeIntegerLiteral(this, _, result)
  }
}

/**
 * An expression that returns a floating-point literal value.
 */
class SemFloatingPointLiteralExpr extends SemNumericLiteralExpr {
  float value;

  SemFloatingPointLiteralExpr() { Specific::floatingPointLiteral(this, _, value) }

  final override float getApproximateFloatValue() { result = value }

  /** Gets the value of the literal. */
  final float getFloatValue() { result = value }
}

/**
 * An expression that consumes two operands.
 */
class SemBinaryExpr extends SemKnownExpr {
  SemExpr leftOperand;
  SemExpr rightOperand;

  SemBinaryExpr() { Specific::binaryExpr(this, opcode, type, leftOperand, rightOperand) }

  /** Gets the left operand. */
  final SemExpr getLeftOperand() { result = leftOperand }

  /** Gets the right operand. */
  final SemExpr getRightOperand() { result = rightOperand }

  /** Holds if `a` and `b` are the two operands, in either order. */
  final predicate hasOperands(SemExpr a, SemExpr b) {
    a = getLeftOperand() and b = getRightOperand()
    or
    a = getRightOperand() and b = getLeftOperand()
  }

  /** Gets the two operands. */
  final SemExpr getAnOperand() { result = getLeftOperand() or result = getRightOperand() }
}

/** An expression that performs and ordered comparison of two operands. */
class SemRelationalExpr extends SemBinaryExpr {
  SemRelationalExpr() {
    opcode instanceof Opcode::CompareLT
    or
    opcode instanceof Opcode::CompareLE
    or
    opcode instanceof Opcode::CompareGT
    or
    opcode instanceof Opcode::CompareGE
  }

  /**
   * Get the operand that will be less than the other operand if the result of the comparison is
   * `true`.
   *
   * For `x < y` or `x <= y`, this will return `x`.
   * For `x > y` or `x >= y`, this will return `y`.`
   */
  final SemExpr getLesserOperand() {
    if opcode instanceof Opcode::CompareLT or opcode instanceof Opcode::CompareLE
    then result = getLeftOperand()
    else result = getRightOperand()
  }

  /**
   * Get the operand that will be greater than the other operand if the result of the comparison is
   * `true`.
   *
   * For `x < y` or `x <= y`, this will return `y`.
   * For `x > y` or `x >= y`, this will return `x`.`
   */
  final SemExpr getGreaterOperand() {
    if opcode instanceof Opcode::CompareGT or opcode instanceof Opcode::CompareGE
    then result = getLeftOperand()
    else result = getRightOperand()
  }

  /** Holds if this comparison returns `false` if the two operands are equal. */
  final predicate isStrict() {
    opcode instanceof Opcode::CompareLT or opcode instanceof Opcode::CompareGT
  }
}

class SemAddExpr extends SemBinaryExpr {
  SemAddExpr() { opcode instanceof Opcode::Add }
}

class SemSubExpr extends SemBinaryExpr {
  SemSubExpr() { opcode instanceof Opcode::Sub }
}

class SemMulExpr extends SemBinaryExpr {
  SemMulExpr() { opcode instanceof Opcode::Mul }
}

class SemDivExpr extends SemBinaryExpr {
  SemDivExpr() { opcode instanceof Opcode::Div }
}

class SemRemExpr extends SemBinaryExpr {
  SemRemExpr() { opcode instanceof Opcode::Rem }
}

class SemShiftLeftExpr extends SemBinaryExpr {
  SemShiftLeftExpr() { opcode instanceof Opcode::ShiftLeft }
}

class SemShiftRightExpr extends SemBinaryExpr {
  SemShiftRightExpr() { opcode instanceof Opcode::ShiftRight }
}

class SemShiftRightUnsignedExpr extends SemBinaryExpr {
  SemShiftRightUnsignedExpr() { opcode instanceof Opcode::ShiftRightUnsigned }
}

class SemBitAndExpr extends SemBinaryExpr {
  SemBitAndExpr() { opcode instanceof Opcode::BitAnd }
}

class SemBitOrExpr extends SemBinaryExpr {
  SemBitOrExpr() { opcode instanceof Opcode::BitOr }
}

class SemBitXorExpr extends SemBinaryExpr {
  SemBitXorExpr() { opcode instanceof Opcode::BitXor }
}

class SemUnaryExpr extends SemKnownExpr {
  SemExpr operand;

  SemUnaryExpr() { Specific::unaryExpr(this, opcode, type, operand) }

  final SemExpr getOperand() { result = operand }
}

class SemBoxExpr extends SemUnaryExpr {
  SemBoxExpr() { opcode instanceof Opcode::Box }
}

class SemUnboxExpr extends SemUnaryExpr {
  SemUnboxExpr() { opcode instanceof Opcode::Unbox }
}

class SemConvertExpr extends SemUnaryExpr {
  SemConvertExpr() { opcode instanceof Opcode::Convert }
}

class SemCopyValueExpr extends SemUnaryExpr {
  SemCopyValueExpr() { opcode instanceof Opcode::CopyValue }
}

class SemNegateExpr extends SemUnaryExpr {
  SemNegateExpr() { opcode instanceof Opcode::Negate }
}

class SemBitComplementExpr extends SemUnaryExpr {
  SemBitComplementExpr() { opcode instanceof Opcode::BitComplement }
}

class SemLogicalNotExpr extends SemUnaryExpr {
  SemLogicalNotExpr() { opcode instanceof Opcode::LogicalNot }
}

class SemAddOneExpr extends SemUnaryExpr {
  SemAddOneExpr() { opcode instanceof Opcode::AddOne }
}

class SemSubOneExpr extends SemUnaryExpr {
  SemSubOneExpr() { opcode instanceof Opcode::SubOne }
}

private class SemNullaryExpr extends SemKnownExpr {
  SemNullaryExpr() { Specific::nullaryExpr(this, opcode, type) }
}

class SemInitializeParameterExpr extends SemNullaryExpr {
  SemInitializeParameterExpr() { opcode instanceof Opcode::InitializeParameter }
}

class SemLoadExpr extends SemNullaryExpr {
  SemLoadExpr() { opcode instanceof Opcode::Load }

  final SemSsaVariable getDef() { result.getAUse() = this }
}

class SemSsaLoadExpr extends SemLoadExpr {
  SemSsaLoadExpr() { exists(getDef()) }
}

class SemNonSsaLoadExpr extends SemLoadExpr {
  SemNonSsaLoadExpr() { not exists(getDef()) }
}

class SemStoreExpr extends SemUnaryExpr {
  SemStoreExpr() { opcode instanceof Opcode::Store }
}

class SemConditionalExpr extends SemKnownExpr {
  SemExpr condition;
  SemExpr trueResult;
  SemExpr falseResult;

  SemConditionalExpr() {
    opcode instanceof Opcode::Conditional and
    Specific::conditionalExpr(this, type, condition, trueResult, falseResult)
  }

  final SemExpr getBranchExpr(boolean branch) {
    branch = true and result = trueResult
    or
    branch = false and result = falseResult
  }
}
