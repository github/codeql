private import semmle.code.binary.ast.instructions as Raw
private import TranslatedElement
private import codeql.util.Option
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import semmle.code.binary.ast.ir.internal.InstructionTag
private import TranslatedInstruction
private import Instruction
private import Operand
private import codeql.controlflow.SuccessorType
private import Variable

abstract class TranslatedOperand extends TranslatedElement {
  Raw::Operand op;

  override Raw::Element getRawElement() { result = op }

  TranslatedInstruction getUse() { result = getTranslatedInstruction(op.getUse()) }

  abstract Option<Instruction>::Option getEntry();

  final override string getDumpId() {
    result = "op_" + op.getUse().getIndex() + "_" + op.getIndex()
  }

  final override string toString() { result = "Translation of " + op }
}

TranslatedOperand getTranslatedOperand(Raw::Operand op) {
  result.getRawElement() = op and
  result.producesResult()
}

class TranslatedRegisterOperand extends TranslatedOperand, TTranslatedRegisterOperand {
  override Raw::RegisterOperand op;

  TranslatedRegisterOperand() { this = TTranslatedRegisterOperand(op) }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  override predicate producesResult() { any() }

  override Variable getResultVariable() { result = getTranslatedVariableReal(op.getRegister()) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    none()
  }

  override Option<Instruction>::Option getEntry() { result.isNone() }
}

/**
 * Compile an immediate operand (such as 0x48) into:
 * ```
 * r1 = Const(0x48)
 * ```
 */
class TranslatedImmediateOperand extends TranslatedOperand, TTranslatedImmediateOperand {
  override Raw::ImmediateOperand op;

  TranslatedImmediateOperand() { this = TTranslatedImmediateOperand(op) }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = ImmediateOperandConstTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(op.getUse()).getChildSuccessor(this, succType)
  }

  override predicate producesResult() { any() }

  override predicate hasTempVariable(VariableTag tag) { tag = ImmediateOperandVarTag() }

  override Variable getResultVariable() { result = this.getVariable(ImmediateOperandVarTag()) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override int getConstantValue(InstructionTag tag) {
    tag = ImmediateOperandConstTag() and
    result = op.getValue()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    opcode instanceof Opcode::Const and
    tag = ImmediateOperandConstTag() and
    v.asSome() = this.getVariable(ImmediateOperandVarTag())
  }

  override Option<Instruction>::Option getEntry() {
    result.asSome() = this.getInstruction(ImmediateOperandConstTag())
  }
}

class TranslatedMemoryOperand extends TranslatedOperand, TTranslatedMemoryOperand {
  override Raw::MemoryOperand op;

  TranslatedMemoryOperand() { this = TTranslatedMemoryOperand(op) }

  private predicate isLoaded() { this.getUse().isOperandLoaded(op) }

  private Instruction getSuccessorAfterLoad(InstructionTag tag, SuccessorType succType) {
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(op.getUse()).getChildSuccessor(this, succType)
  }

  private Instruction getLoadSuccessorOrExit(SuccessorType succType) {
    succType instanceof DirectSuccessor and
    if this.isLoaded()
    then result = this.getInstruction(MemoryOperandLoadTag())
    else result = getTranslatedInstruction(op.getUse()).getChildSuccessor(this, succType)
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    this.case1Applies() and
    (
      tag = MemoryOperandConstFactorTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandMulTag())
      or
      tag = MemoryOperandMulTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandAdd1Tag())
      or
      tag = MemoryOperandAdd1Tag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandAdd2Tag())
      or
      tag = MemoryOperandAdd2Tag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
    or
    this.case2Applies() and
    (
      tag = MemoryOperandConstFactorTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandMulTag())
      or
      tag = MemoryOperandMulTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandAdd1Tag())
      or
      tag = MemoryOperandAdd1Tag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
    or
    this.case3Applies() and
    (
      tag = MemoryOperandConstDisplacementTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandAdd1Tag())
      or
      tag = MemoryOperandAdd1Tag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandAdd2Tag())
      or
      tag = MemoryOperandAdd2Tag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
    or
    this.case4Applies() and
    (
      tag = MemoryOperandAdd1Tag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
    or
    this.case5Applies() and
    (
      tag = MemoryOperandConstDisplacementTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandAdd1Tag())
      or
      tag = MemoryOperandAdd1Tag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
    or
    this.case6Applies() and
    result = this.getSuccessorAfterLoad(tag, succType)
    or
    this.case7Applies() and
    (
      tag = MemoryOperandConstFactorTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandMulTag())
      or
      tag = MemoryOperandMulTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandAdd1Tag())
      or
      tag = MemoryOperandAdd1Tag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
    or
    this.case8Applies() and
    (
      tag = MemoryOperandConstFactorTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandMulTag())
      or
      tag = MemoryOperandMulTag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
    or
    this.case9Applies() and
    (
      tag = MemoryOperandConstDisplacementTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(MemoryOperandAdd1Tag())
      or
      tag = MemoryOperandAdd1Tag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
    or
    this.case10Applies() and
    result = this.getSuccessorAfterLoad(tag, succType)
    or
    this.case11Applies() and
    (
      tag = MemoryOperandConstDisplacementTag() and
      result = this.getLoadSuccessorOrExit(succType)
      or
      result = this.getSuccessorAfterLoad(tag, succType)
    )
  }

  override predicate producesResult() { any() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  Variable getAddressVariable() {
    this.case1Applies() and
    result = this.getInstruction(MemoryOperandAdd2Tag()).getResultVariable()
    or
    this.case2Applies() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    or
    this.case3Applies() and
    result = this.getInstruction(MemoryOperandAdd2Tag()).getResultVariable()
    or
    this.case4Applies() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    or
    this.case5Applies() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    or
    this.case6Applies() and
    result = getTranslatedVariableReal(op.getBaseRegister().getTarget())
    or
    this.case7Applies() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    or
    this.case8Applies() and
    result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
    or
    this.case9Applies() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    or
    this.case10Applies() and
    result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
    or
    this.case11Applies() and
    result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
  }

  private predicate hasScaleFactor() { op.getScaleFactor() != 1 }

  private predicate hasIndex() { exists(op.getIndexRegister()) }

  private predicate hasDisplacementValue() { op.getDisplacementValue() != 0 }

  private predicate hasBase() { exists(op.getBaseRegister()) }

  override int getConstantValue(InstructionTag tag) {
    this.hasScaleFactor() and
    tag = MemoryOperandConstFactorTag() and
    result = op.getScaleFactor()
    or
    this.hasDisplacementValue() and
    tag = MemoryOperandConstDisplacementTag() and
    result = op.getDisplacementValue()
  }

  override Variable getResultVariable() {
    this.case1Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandAdd2Tag()).getResultVariable()
    )
    or
    this.case2Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    )
    or
    this.case3Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandAdd2Tag()).getResultVariable()
    )
    or
    this.case4Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    )
    or
    this.case5Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    )
    or
    this.case6Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = getTranslatedVariableReal(op.getBaseRegister().getTarget())
    )
    or
    this.case7Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    )
    or
    this.case8Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
    )
    or
    this.case9Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    )
    or
    this.case10Applies() and
    if this.isLoaded()
    then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
    else result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
    or
    this.case11Applies() and
    (
      if this.isLoaded()
      then result = this.getInstruction(MemoryOperandLoadTag()).getResultVariable()
      else result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
    )
  }

  // Compute base + index * factor + displacement
  Variable case1(InstructionTag tag, OperandTag operandTag) {
    // x = index * factor
    tag = MemoryOperandMulTag() and
    (
      operandTag = LeftTag() and
      result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstFactorTag()).getResultVariable()
    )
    or
    // x = x + base
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag = LeftTag() and
      result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
      or
      operandTag = RightTag() and
      result = getTranslatedVariableReal(op.getBaseRegister().getTarget())
    )
    or
    // x = x + displacement
    tag = MemoryOperandAdd2Tag() and
    (
      operandTag = LeftTag() and
      result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandAdd2Tag()).getResultVariable()
  }

  // Compute base + index * scale
  Variable case2(InstructionTag tag, OperandTag operandTag) {
    // x = index * factor
    tag = MemoryOperandMulTag() and
    (
      operandTag = LeftTag() and
      result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstFactorTag()).getResultVariable()
    )
    or
    // x = x + base
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag = LeftTag() and
      result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
      or
      operandTag = RightTag() and
      result = getTranslatedVariableReal(op.getBaseRegister().getTarget())
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute base + index + displacement
  Variable case3(InstructionTag tag, OperandTag operandTag) {
    // x = base + index
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag = LeftTag() and
      result = getTranslatedVariableReal(op.getBaseRegister().getTarget())
      or
      operandTag = RightTag() and
      result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
    )
    or
    // x = x + displacement
    tag = MemoryOperandAdd2Tag() and
    (
      operandTag = LeftTag() and
      result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandAdd2Tag()).getResultVariable()
  }

  // Compute base + index
  Variable case4(InstructionTag tag, OperandTag operandTag) {
    // x = base + index
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag = LeftTag() and
      result = getTranslatedVariableReal(op.getBaseRegister().getTarget())
      or
      operandTag = RightTag() and
      result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute base + displacement
  Variable case5(InstructionTag tag, OperandTag operandTag) {
    // x = base + displacement
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag = LeftTag() and
      result = getTranslatedVariableReal(op.getBaseRegister().getTarget())
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute base
  Variable case6(InstructionTag tag, OperandTag operandTag) {
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = getTranslatedVariableReal(op.getBaseRegister().getTarget())
    // If we are in case6 and we do not need to load the result will be the base register
  }

  // Compute index * scale + displacement
  Variable case7(InstructionTag tag, OperandTag operandTag) {
    // x = index * factor
    tag = MemoryOperandMulTag() and
    (
      operandTag = LeftTag() and
      result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstFactorTag()).getResultVariable()
    )
    or
    // x = x + displacement
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag = LeftTag() and
      result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute index * factor
  Variable case8(InstructionTag tag, OperandTag operandTag) {
    // x = index * factor
    tag = MemoryOperandMulTag() and
    (
      operandTag = LeftTag() and
      result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstFactorTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
  }

  // Compute index + displacement
  Variable case9(InstructionTag tag, OperandTag operandTag) {
    // x = index + displacement
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag = LeftTag() and
      result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
      or
      operandTag = RightTag() and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute index
  Variable case10(InstructionTag tag, OperandTag operandTag) {
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = getTranslatedVariableReal(op.getIndexRegister().getTarget())
    // If we are in case10 and we do not need to load the result will be the index register
  }

  // Compute displacement
  Variable case11(InstructionTag tag, OperandTag operandTag) {
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag = UnaryTag() and
    result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    // If we are in case11 and we do not need to load the result will be the displacement constant
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * base + index * scale + displacement
   */
  private predicate case1Applies() {
    this.hasDisplacementValue() and this.hasScaleFactor() and this.hasIndex() and this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * base + index * scale
   */
  private predicate case2Applies() {
    not this.hasDisplacementValue() and this.hasScaleFactor() and this.hasIndex() and this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * base + index + displacement
   */
  private predicate case3Applies() {
    this.hasDisplacementValue() and not this.hasScaleFactor() and this.hasIndex() and this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * index + base
   */
  private predicate case4Applies() {
    not this.hasDisplacementValue() and
    not this.hasScaleFactor() and
    this.hasIndex() and
    this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * base + displacement
   */
  private predicate case5Applies() {
    this.hasDisplacementValue() and not this.hasIndex() and this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * base
   */
  private predicate case6Applies() {
    not this.hasDisplacementValue() and not this.hasIndex() and this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * index * scale + displacement
   */
  private predicate case7Applies() {
    this.hasDisplacementValue() and this.hasScaleFactor() and this.hasIndex() and not this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * index * scale
   */
  private predicate case8Applies() {
    not this.hasDisplacementValue() and
    this.hasScaleFactor() and
    this.hasIndex() and
    not this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * index + displacement
   */
  private predicate case9Applies() {
    this.hasDisplacementValue() and
    not this.hasScaleFactor() and
    this.hasIndex() and
    not this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * index
   */
  private predicate case10Applies() {
    not this.hasDisplacementValue() and
    not this.hasScaleFactor() and
    this.hasIndex() and
    not this.hasBase()
  }

  /**
   * Holds if we need to compute (and possibly load) a value of the form:
   * displacement
   */
  private predicate case11Applies() {
    this.hasDisplacementValue() and not this.hasIndex() and not this.hasBase()
  }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    if this.hasBase()
    then
      if this.hasIndex()
      then
        if this.hasScaleFactor()
        then
          if this.hasDisplacementValue()
          then result = this.case1(tag, operandTag)
          else result = this.case2(tag, operandTag)
        else
          if this.hasDisplacementValue()
          then result = this.case3(tag, operandTag)
          else result = this.case4(tag, operandTag)
      else
        if this.hasDisplacementValue()
        then result = this.case5(tag, operandTag)
        else result = this.case6(tag, operandTag)
    else
      if this.hasIndex()
      then
        if this.hasScaleFactor()
        then
          if this.hasDisplacementValue()
          then result = this.case7(tag, operandTag)
          else result = this.case8(tag, operandTag)
        else
          if this.hasDisplacementValue()
          then result = this.case9(tag, operandTag)
          else result = this.case10(tag, operandTag)
      else result = this.case11(tag, operandTag)
  }

  override predicate hasTempVariable(VariableTag tag) {
    tag = MemoryOperandAdd1VarTag()
    or
    tag = MemoryOperandAdd2VarTag()
    or
    tag = MemoryOperandMulVarTag()
    or
    tag = MemoryOperandLoadVarTag()
    or
    tag = MemoryOperandConstFactorVarTag()
    or
    tag = MemoryOperandConstDisplacementVarTag()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    this.case1Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstFactorTag() and
      v.asSome() = this.getVariable(MemoryOperandConstFactorVarTag())
      or
      opcode instanceof Opcode::Mul and
      tag = MemoryOperandMulTag() and
      v.asSome() = this.getVariable(MemoryOperandMulVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getVariable(MemoryOperandAdd1VarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd2Tag() and
      v.asSome() = this.getVariable(MemoryOperandAdd2VarTag())
    )
    or
    this.case2Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstFactorTag() and
      v.asSome() = this.getVariable(MemoryOperandConstFactorVarTag())
      or
      opcode instanceof Opcode::Mul and
      tag = MemoryOperandMulTag() and
      v.asSome() = this.getVariable(MemoryOperandMulVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getVariable(MemoryOperandAdd1VarTag())
    )
    or
    this.case3Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstDisplacementTag() and
      v.asSome() = this.getVariable(MemoryOperandConstDisplacementVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getVariable(MemoryOperandAdd1VarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd2Tag() and
      v.asSome() = this.getVariable(MemoryOperandAdd2VarTag())
    )
    or
    this.case4Applies() and
    opcode instanceof Opcode::Add and
    tag = MemoryOperandAdd1Tag() and
    v.asSome() = this.getVariable(MemoryOperandAdd1VarTag())
    or
    this.case5Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstDisplacementTag() and
      v.asSome() = this.getVariable(MemoryOperandConstDisplacementVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getVariable(MemoryOperandAdd1VarTag())
    )
    or
    this.case6Applies() and
    none()
    or
    this.case7Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstFactorTag() and
      v.asSome() = this.getVariable(MemoryOperandConstFactorVarTag())
      or
      opcode instanceof Opcode::Mul and
      tag = MemoryOperandMulTag() and
      v.asSome() = this.getVariable(MemoryOperandMulVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getVariable(MemoryOperandAdd1VarTag())
    )
    or
    this.case8Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstFactorTag() and
      v.asSome() = this.getVariable(MemoryOperandConstFactorVarTag())
      or
      opcode instanceof Opcode::Mul and
      tag = MemoryOperandMulTag() and
      v.asSome() = this.getVariable(MemoryOperandMulVarTag())
    )
    or
    this.case9Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstDisplacementTag() and
      v.asSome() = this.getVariable(MemoryOperandConstDisplacementVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getVariable(MemoryOperandAdd1VarTag())
    )
    or
    this.case10Applies() and
    none()
    or
    this.case11Applies() and
    opcode instanceof Opcode::Const and
    tag = MemoryOperandConstDisplacementTag() and
    v.asSome() = this.getVariable(MemoryOperandConstDisplacementVarTag())
    or
    this.isLoaded() and
    opcode instanceof Opcode::Load and
    tag = MemoryOperandLoadTag() and
    v.asSome() = this.getVariable(MemoryOperandLoadVarTag())
  }

  override Option<Instruction>::Option getEntry() {
    this.case1Applies() and
    result.asSome() = this.getInstruction(MemoryOperandConstFactorTag())
    or
    this.case2Applies() and
    result.asSome() = this.getInstruction(MemoryOperandConstFactorTag())
    or
    this.case3Applies() and
    result.asSome() = this.getInstruction(MemoryOperandConstDisplacementTag())
    or
    this.case4Applies() and
    result.asSome() = this.getInstruction(MemoryOperandAdd1Tag())
    or
    this.case5Applies() and
    result.asSome() = this.getInstruction(MemoryOperandConstDisplacementTag())
    or
    this.case6Applies() and
    (
      if this.isLoaded()
      then result.asSome() = this.getInstruction(MemoryOperandLoadTag())
      else result.isNone()
    )
    or
    this.case7Applies() and
    result.asSome() = this.getInstruction(MemoryOperandConstFactorTag())
    or
    this.case8Applies() and
    result.asSome() = this.getInstruction(MemoryOperandConstFactorTag())
    or
    this.case9Applies() and
    result.asSome() = this.getInstruction(MemoryOperandConstDisplacementTag())
    or
    this.case10Applies() and
    (
      if this.isLoaded()
      then result.asSome() = this.getInstruction(MemoryOperandLoadTag())
      else result.isNone()
    )
    or
    this.case11Applies() and
    result.asSome() = this.getInstruction(MemoryOperandConstDisplacementTag())
  }
}
