private import semmle.code.binary.ast.Location
private import semmle.code.binary.ast.instructions as Raw
private import TranslatedElement
private import codeql.util.Option
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import semmle.code.binary.ast.ir.internal.Tags
private import InstructionTag
private import TranslatedInstruction
private import Instruction
private import Operand
private import codeql.controlflow.SuccessorType
private import Variable
private import TempVariableTag
private import TranslatedFunction

abstract class TranslatedOperand extends TranslatedElement {
  abstract TranslatedInstruction getUse();

  abstract Option<Instruction>::Option getEntry();

  final override TranslatedFunction getEnclosingFunction() {
    result = this.getUse().getEnclosingFunction()
  }
}

abstract class TranslatedX86Operand extends TranslatedOperand {
  Raw::X86Operand op;

  final override string getDumpId() {
    result = "op_" + op.getUse().getIndex() + "_" + op.getIndex()
  }

  override Raw::Element getRawElement() { result = op }

  final Variable getX86RegisterVariable(Raw::X86Register r) {
    result = this.getLocalVariable(X86RegisterTag(r))
  }

  final override TranslatedX86Instruction getUse() {
    result = getTranslatedInstruction(op.getUse())
  }

  final override string toString() { result = "Translation of " + op }

  final override Location getLocation() { none() } // TODO: Implement this
}

TranslatedOperand getTranslatedOperand(Raw::Element op) {
  result.getRawElement() = op and
  result.producesResult()
}

class TranslatedX86RegisterOperand extends TranslatedX86Operand, TTranslatedX86RegisterOperand {
  override Raw::X86RegisterOperand op;

  TranslatedX86RegisterOperand() { this = TTranslatedX86RegisterOperand(op) }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  override predicate producesResult() { any() }

  override Variable getResultVariable() { result = this.getX86RegisterVariable(op.getRegister()) }

  override predicate hasLocalVariable(LocalVariableTag tag) {
    tag = X86RegisterTag(op.getRegister())
  }

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
class TranslatedX86ImmediateOperand extends TranslatedX86Operand, TTranslatedX86ImmediateOperand {
  override Raw::X86ImmediateOperand op;

  TranslatedX86ImmediateOperand() { this = TTranslatedX86ImmediateOperand(op) }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = ImmediateOperandConstTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(op.getUse()).getChildSuccessor(this, succType)
  }

  override predicate producesResult() { any() }

  override predicate hasTempVariable(TempVariableTag tag) { tag = ImmediateOperandVarTag() }

  override Variable getResultVariable() { result = this.getTempVariable(ImmediateOperandVarTag()) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override int getConstantValue(InstructionTag tag) {
    tag = ImmediateOperandConstTag() and
    result = op.getValue()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    opcode instanceof Opcode::Const and
    tag = ImmediateOperandConstTag() and
    v.asSome() = this.getTempVariable(ImmediateOperandVarTag())
  }

  override Option<Instruction>::Option getEntry() {
    result.asSome() = this.getInstruction(ImmediateOperandConstTag())
  }
}

class TranslatedX86MemoryOperand extends TranslatedX86Operand, TTranslatedX86MemoryOperand {
  override Raw::X86MemoryOperand op;

  TranslatedX86MemoryOperand() { this = TTranslatedX86MemoryOperand(op) }

  private predicate isLoaded() { this.getUse().isOperandLoaded(op) }

  override predicate hasLocalVariable(LocalVariableTag tag) {
    tag = X86RegisterTag(op.getBaseRegister().getTarget())
    or
    tag = X86RegisterTag(op.getIndexRegister().getTarget())
  }

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
    result = this.getX86RegisterVariable(op.getBaseRegister().getTarget())
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
    result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
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
      else result = this.getX86RegisterVariable(op.getBaseRegister().getTarget())
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
    else result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
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
      operandTag instanceof LeftTag and
      result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstFactorTag()).getResultVariable()
    )
    or
    // x = x + base
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getX86RegisterVariable(op.getBaseRegister().getTarget())
    )
    or
    // x = x + displacement
    tag = MemoryOperandAdd2Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(MemoryOperandAdd2Tag()).getResultVariable()
  }

  // Compute base + index * scale
  Variable case2(InstructionTag tag, OperandTag operandTag) {
    // x = index * factor
    tag = MemoryOperandMulTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstFactorTag()).getResultVariable()
    )
    or
    // x = x + base
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getX86RegisterVariable(op.getBaseRegister().getTarget())
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute base + index + displacement
  Variable case3(InstructionTag tag, OperandTag operandTag) {
    // x = base + index
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getX86RegisterVariable(op.getBaseRegister().getTarget())
      or
      operandTag instanceof RightTag and
      result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
    )
    or
    // x = x + displacement
    tag = MemoryOperandAdd2Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(MemoryOperandAdd2Tag()).getResultVariable()
  }

  // Compute base + index
  Variable case4(InstructionTag tag, OperandTag operandTag) {
    // x = base + index
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getX86RegisterVariable(op.getBaseRegister().getTarget())
      or
      operandTag instanceof RightTag and
      result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute base + displacement
  Variable case5(InstructionTag tag, OperandTag operandTag) {
    // x = base + displacement
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getX86RegisterVariable(op.getBaseRegister().getTarget())
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute base
  Variable case6(InstructionTag tag, OperandTag operandTag) {
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getX86RegisterVariable(op.getBaseRegister().getTarget())
    // If we are in case6 and we do not need to load the result will be the base register
  }

  // Compute index * scale + displacement
  Variable case7(InstructionTag tag, OperandTag operandTag) {
    // x = index * factor
    tag = MemoryOperandMulTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstFactorTag()).getResultVariable()
    )
    or
    // x = x + displacement
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute index * factor
  Variable case8(InstructionTag tag, OperandTag operandTag) {
    // x = index * factor
    tag = MemoryOperandMulTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstFactorTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(MemoryOperandMulTag()).getResultVariable()
  }

  // Compute index + displacement
  Variable case9(InstructionTag tag, OperandTag operandTag) {
    // x = index + displacement
    tag = MemoryOperandAdd1Tag() and
    (
      operandTag instanceof LeftTag and
      result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(MemoryOperandConstDisplacementTag()).getResultVariable()
    )
    or
    // Load from [x]
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(MemoryOperandAdd1Tag()).getResultVariable()
  }

  // Compute index
  Variable case10(InstructionTag tag, OperandTag operandTag) {
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getX86RegisterVariable(op.getIndexRegister().getTarget())
    // If we are in case10 and we do not need to load the result will be the index register
  }

  // Compute displacement
  Variable case11(InstructionTag tag, OperandTag operandTag) {
    this.isLoaded() and
    tag = MemoryOperandLoadTag() and
    operandTag instanceof LoadAddressTag and
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

  override predicate hasTempVariable(TempVariableTag tag) {
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
      v.asSome() = this.getTempVariable(MemoryOperandConstFactorVarTag())
      or
      opcode instanceof Opcode::Mul and
      tag = MemoryOperandMulTag() and
      v.asSome() = this.getTempVariable(MemoryOperandMulVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getTempVariable(MemoryOperandAdd1VarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd2Tag() and
      v.asSome() = this.getTempVariable(MemoryOperandAdd2VarTag())
    )
    or
    this.case2Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstFactorTag() and
      v.asSome() = this.getTempVariable(MemoryOperandConstFactorVarTag())
      or
      opcode instanceof Opcode::Mul and
      tag = MemoryOperandMulTag() and
      v.asSome() = this.getTempVariable(MemoryOperandMulVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getTempVariable(MemoryOperandAdd1VarTag())
    )
    or
    this.case3Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstDisplacementTag() and
      v.asSome() = this.getTempVariable(MemoryOperandConstDisplacementVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getTempVariable(MemoryOperandAdd1VarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd2Tag() and
      v.asSome() = this.getTempVariable(MemoryOperandAdd2VarTag())
    )
    or
    this.case4Applies() and
    opcode instanceof Opcode::Add and
    tag = MemoryOperandAdd1Tag() and
    v.asSome() = this.getTempVariable(MemoryOperandAdd1VarTag())
    or
    this.case5Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstDisplacementTag() and
      v.asSome() = this.getTempVariable(MemoryOperandConstDisplacementVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getTempVariable(MemoryOperandAdd1VarTag())
    )
    or
    this.case6Applies() and
    none()
    or
    this.case7Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstFactorTag() and
      v.asSome() = this.getTempVariable(MemoryOperandConstFactorVarTag())
      or
      opcode instanceof Opcode::Mul and
      tag = MemoryOperandMulTag() and
      v.asSome() = this.getTempVariable(MemoryOperandMulVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getTempVariable(MemoryOperandAdd1VarTag())
    )
    or
    this.case8Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstFactorTag() and
      v.asSome() = this.getTempVariable(MemoryOperandConstFactorVarTag())
      or
      opcode instanceof Opcode::Mul and
      tag = MemoryOperandMulTag() and
      v.asSome() = this.getTempVariable(MemoryOperandMulVarTag())
    )
    or
    this.case9Applies() and
    (
      opcode instanceof Opcode::Const and
      tag = MemoryOperandConstDisplacementTag() and
      v.asSome() = this.getTempVariable(MemoryOperandConstDisplacementVarTag())
      or
      opcode instanceof Opcode::Add and
      tag = MemoryOperandAdd1Tag() and
      v.asSome() = this.getTempVariable(MemoryOperandAdd1VarTag())
    )
    or
    this.case10Applies() and
    none()
    or
    this.case11Applies() and
    opcode instanceof Opcode::Const and
    tag = MemoryOperandConstDisplacementTag() and
    v.asSome() = this.getTempVariable(MemoryOperandConstDisplacementVarTag())
    or
    this.isLoaded() and
    opcode instanceof Opcode::Load and
    tag = MemoryOperandLoadTag() and
    v.asSome() = this.getTempVariable(MemoryOperandLoadVarTag())
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
