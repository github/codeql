import cpp
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr

abstract class TranslatedConversion extends TranslatedNonConstantExpr {
  Conversion conv;

  TranslatedConversion() {
    conv = expr
  }

  override Instruction getFirstInstruction() {
    result = getOperand().getFirstInstruction()
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getOperand()
  }

  final TranslatedExpr getOperand() {
    result = getTranslatedExpr(expr.(Conversion).getExpr())
  }
}

/**
 * Represents the translation of a conversion expression that generates a
 * single instruction.
 */
abstract class TranslatedSingleInstructionConversion extends TranslatedConversion {
  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getOperand() and result = getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode = getOpcode() and
    resultType = getResultType() and
    isGLValue = isResultGLValue()
  }

  override Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperand and
    result = getOperand().getResult()
  }

  /**
   * Gets the opcode of the generated instruction.
   */
  abstract Opcode getOpcode();
}

/**
 * Represents the translation of a conversion expression that generates a
 * `Convert` instruction.
 */
class TranslatedSimpleConversion extends TranslatedSingleInstructionConversion {
  TranslatedSimpleConversion() {
    conv instanceof ArithmeticConversion or
    conv instanceof PointerConversion or
    conv instanceof PointerToMemberConversion or
    conv instanceof PointerToIntegralConversion or
    conv instanceof IntegralToPointerConversion or
    conv instanceof GlvalueConversion or
    conv instanceof ArrayToPointerConversion or
    conv instanceof PrvalueAdjustmentConversion or
    conv instanceof VoidConversion
  }

  override Opcode getOpcode() {
    result instanceof Opcode::Convert
  }
}

/**
 * Represents the translation of a dynamic_cast expression.
 */
class TranslatedDynamicCast extends TranslatedSingleInstructionConversion {
  TranslatedDynamicCast() {
    conv instanceof DynamicCast
  }

  override Opcode getOpcode() {
    exists(Type resultType |
      resultType = getResultType() and
      if resultType instanceof PointerType then (
        if resultType.(PointerType).getBaseType() instanceof VoidType then
          result instanceof Opcode::DynamicCastToVoid
        else
          result instanceof Opcode::CheckedConvertOrNull
      )
      else
        result instanceof Opcode::CheckedConvertOrThrow
    )
  }
}

/**
 * Represents the translation of a `BaseClassConversion` or `DerivedClassConversion`
 * expression.
 */
class TranslatedInheritanceConversion extends TranslatedSingleInstructionConversion {
  InheritanceConversion inheritanceConv;

  TranslatedInheritanceConversion() {
    inheritanceConv = conv
  }

  override predicate getInstructionInheritance(InstructionTag tag, Class baseClass,
    Class derivedClass) {
    tag = OnlyInstructionTag() and
    baseClass = inheritanceConv.getBaseClass() and
    derivedClass = inheritanceConv.getDerivedClass()
  }

  override Opcode getOpcode() {
    if inheritanceConv instanceof BaseClassConversion then (
      if inheritanceConv.(BaseClassConversion).isVirtual() then
        result instanceof Opcode::ConvertToVirtualBase
      else
        result instanceof Opcode::ConvertToBase
    )
    else
      result instanceof Opcode::ConvertToDerived
  }
}

/**
 * Represents the translation of a `BoolConversion` expression, which generates
 * a comparison with zero.
 */
class TranslatedBoolConversion extends TranslatedConversion {
  TranslatedBoolConversion() {
    conv instanceof BoolConversion
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = BoolConversionConstantTag() and
        result = getInstruction(BoolConversionCompareTag())
      ) or
      (
        tag = BoolConversionCompareTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getOperand() and result = getInstruction(BoolConversionConstantTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    isGLValue = false and
    (
      (
        tag = BoolConversionConstantTag() and
        opcode instanceof Opcode::Constant and
        resultType = getOperand().getResultType()
      ) or
      (
        tag = BoolConversionCompareTag() and
        opcode instanceof Opcode::CompareNE and
        resultType instanceof BoolType
      )
    )
  }

  override Instruction getResult() {
    result = getInstruction(BoolConversionCompareTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = BoolConversionCompareTag() and
    (
      (
        operandTag instanceof LeftOperand and
        result = getOperand().getResult()
      ) or
      (
        operandTag instanceof RightOperand and
        result = getInstruction(BoolConversionConstantTag())
      )
    )
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = BoolConversionConstantTag() and
    result = "0"
  }
}
