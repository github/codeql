/**
 * Semantic interface for expressions.
 */

private import java
private import SemanticCFG
private import SemanticSSA
private import SemanticType
private import SemanticExprSpecific::SemanticExprConfig as Specific

private newtype TOpcode =
  TInitializeParameter() or
  TCopyValue() or
  TLoad() or
  TStore() or
  TAdd() or
  TSub() or
  TMul() or
  TDiv() or
  TRem() or
  TNegate() or
  TShiftLeft() or
  TShiftRight() or
  TShiftRightUnsigned() or // TODO: Based on type
  TBitAnd() or
  TBitOr() or
  TBitXor() or
  TBitComplement() or
  TLogicalNot() or
  TCompareEQ() or
  TCompareNE() or
  TCompareLT() or
  TCompareGT() or
  TCompareLE() or
  TCompareGE() or
  TPointerAdd() or
  TPointerSub() or
  TPointerDiff() or
  TConvert() or
  TConstant() or
  TStringConstant() or
  TAddOne() or // TODO: Combine with `TAdd`
  TSubOne() or // TODO: Combine with `TSub`
  TConditional() or // TODO: Represent as flow
  TCall() or
  TUnknown()

class Opcode extends TOpcode {
  string toString() { result = "???" }
}

module Opcode {
  class InitializeParameter extends Opcode, TInitializeParameter {
    override string toString() { result = "InitializeParameter" }
  }

  class CopyValue extends Opcode, TCopyValue {
    override string toString() { result = "CopyValue" }
  }

  class Load extends Opcode, TLoad {
    override string toString() { result = "Load" }
  }

  class Store extends Opcode, TStore {
    override string toString() { result = "Store" }
  }

  class Add extends Opcode, TAdd {
    override string toString() { result = "Add" }
  }

  class Sub extends Opcode, TSub {
    override string toString() { result = "Sub" }
  }

  class Mul extends Opcode, TMul {
    override string toString() { result = "Mul" }
  }

  class Div extends Opcode, TDiv {
    override string toString() { result = "Div" }
  }

  class Rem extends Opcode, TRem {
    override string toString() { result = "Rem" }
  }

  class Negate extends Opcode, TNegate {
    override string toString() { result = "Negate" }
  }

  class ShiftLeft extends Opcode, TShiftLeft {
    override string toString() { result = "ShiftLeft" }
  }

  class ShiftRight extends Opcode, TShiftRight {
    override string toString() { result = "ShiftRight" }
  }

  class ShiftRightUnsigned extends Opcode, TShiftRightUnsigned {
    override string toString() { result = "ShiftRightUnsigned" }
  }

  class BitAnd extends Opcode, TBitAnd {
    override string toString() { result = "BitAnd" }
  }

  class BitOr extends Opcode, TBitOr {
    override string toString() { result = "BitOr" }
  }

  class BitXor extends Opcode, TBitXor {
    override string toString() { result = "BitXor" }
  }

  class BitComplement extends Opcode, TBitComplement {
    override string toString() { result = "BitComplement" }
  }

  class LogicalNot extends Opcode, TLogicalNot {
    override string toString() { result = "LogicalNot" }
  }

  class CompareEQ extends Opcode, TCompareEQ {
    override string toString() { result = "CompareEQ" }
  }

  class CompareNE extends Opcode, TCompareNE {
    override string toString() { result = "CompareNE" }
  }

  class CompareLT extends Opcode, TCompareLT {
    override string toString() { result = "CompareLT" }
  }

  class CompareLE extends Opcode, TCompareLE {
    override string toString() { result = "CompareLE" }
  }

  class CompareGT extends Opcode, TCompareGT {
    override string toString() { result = "CompareGT" }
  }

  class CompareGE extends Opcode, TCompareGE {
    override string toString() { result = "CompareGE" }
  }

  class Convert extends Opcode, TConvert {
    override string toString() { result = "Convert" }
  }

  class AddOne extends Opcode, TAddOne {
    override string toString() { result = "AddOne" }
  }

  class SubOne extends Opcode, TSubOne {
    override string toString() { result = "SubOne" }
  }

  class Conditional extends Opcode, TConditional {
    override string toString() { result = "Conditional" }
  }

  class Constant extends Opcode, TConstant {
    override string toString() { result = "Constant" }
  }

  class StringConstant extends Opcode, TStringConstant {
    override string toString() { result = "StringConstant" }
  }

  class Unknown extends Opcode, TUnknown {
    override string toString() { result = "Unknown" }
  }
}

class SemExpr instanceof Specific::Expr {
  final string toString() { result = Specific::exprToString(this) }

  final Location getLocation() { result = Specific::getExprLocation(this) }

  Opcode getOpcode() { result instanceof Opcode::Unknown }

  SemType getSemType() { result = Specific::getUnknownExprType(this) }

  final SemBasicBlock getBasicBlock() { result = Specific::getExprBasicBlock(this) }
}

abstract private class SemKnownExpr extends SemExpr {
  Opcode opcode;
  SemType type;

  final override Opcode getOpcode() { result = opcode }

  final override SemType getSemType() { result = type }
}

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

class SemNumericLiteralExpr extends SemLiteralExpr {
  SemNumericLiteralExpr() {
    Specific::integerLiteral(this, _, _)
    or
    Specific::largeIntegerLiteral(this, _, _)
    or
    Specific::floatingPointLiteral(this, _, _)
  }

  float getApproximateFloatValue() { none() }
}

class SemIntegerLiteralExpr extends SemNumericLiteralExpr {
  SemIntegerLiteralExpr() {
    Specific::integerLiteral(this, _, _)
    or
    Specific::largeIntegerLiteral(this, _, _)
  }

  final int getIntValue() { Specific::integerLiteral(this, _, result) }

  final override float getApproximateFloatValue() {
    result = getIntValue()
    or
    Specific::largeIntegerLiteral(this, _, result)
  }
}

class SemFloatingPointLiteralExpr extends SemNumericLiteralExpr {
  float value;

  SemFloatingPointLiteralExpr() { Specific::floatingPointLiteral(this, _, value) }

  final override float getApproximateFloatValue() { result = value }

  final float getFloatValue() { result = value }
}

class SemBinaryExpr extends SemKnownExpr {
  SemExpr leftOperand;
  SemExpr rightOperand;

  SemBinaryExpr() { Specific::binaryExpr(this, opcode, type, leftOperand, rightOperand) }

  final SemExpr getLeftOperand() { result = leftOperand }

  final SemExpr getRightOperand() { result = rightOperand }

  final predicate hasOperands(SemExpr a, SemExpr b) {
    a = getLeftOperand() and b = getRightOperand()
    or
    a = getRightOperand() and b = getLeftOperand()
  }

  final SemExpr getAnOperand() { result = getLeftOperand() or result = getRightOperand() }
}

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

  final SemExpr getLesserOperand() {
    if opcode instanceof Opcode::CompareLT or opcode instanceof Opcode::CompareLE
    then result = getLeftOperand()
    else result = getRightOperand()
  }

  final SemExpr getGreaterOperand() {
    if opcode instanceof Opcode::CompareGT or opcode instanceof Opcode::CompareGE
    then result = getLeftOperand()
    else result = getRightOperand()
  }

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
