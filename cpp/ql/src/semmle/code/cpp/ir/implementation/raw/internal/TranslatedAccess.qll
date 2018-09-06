import cpp
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction

class TranslatedThisExpr extends TranslatedNonConstantExpr {
  TranslatedThisExpr() {
    expr instanceof ThisExpr
  }

  override final TranslatedElement getChild(int id) {
    none()
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::CopyValue and
    resultType = expr.getType().getUnspecifiedType() and
    isGLValue = false
  }

  override final Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this)
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof CopySourceOperand and
    result = getInitializeThisInstruction()
  }

  private Instruction getInitializeThisInstruction() {
    result = getTranslatedFunction(expr.getEnclosingFunction()).getInitializeThisInstruction()
  }
}

abstract class TranslatedVariableAccess extends TranslatedNonConstantExpr {
  VariableAccess access;

  TranslatedVariableAccess() {
    access = expr
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getQualifier()  // Might not exist
  }

  final TranslatedExpr getQualifier() {
    result = getTranslatedExpr(access.getQualifier().getFullyConverted())
  }

  override Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getQualifier() and result = getInstruction(OnlyInstructionTag())
  }
}

class TranslatedNonFieldVariableAccess extends TranslatedVariableAccess {
  TranslatedNonFieldVariableAccess() {
    not expr instanceof FieldAccess
  }

  override Instruction getFirstInstruction() {
    if exists(getQualifier()) then
      result = getQualifier().getFirstInstruction()
    else
      result = getInstruction(OnlyInstructionTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    none()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getResultType() and
    isGLValue = true
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = getIRUserVariable(access.getEnclosingFunction(), 
      access.getTarget())
  }
}

class TranslatedFieldAccess extends TranslatedVariableAccess {
  FieldAccess fieldAccess;

  TranslatedFieldAccess() {
    //REVIEW: Implicit 'this'?
    fieldAccess = access
  }

  override Instruction getFirstInstruction() {
    result = getQualifier().getFirstInstruction()
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperand and
    result = getQualifier().getResult()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = getResultType() and
    isGLValue = true
  }

  override Field getInstructionField(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = access.getTarget()
  }
}

class TranslatedFunctionAccess extends TranslatedNonConstantExpr {
  FunctionAccess access;

  TranslatedFunctionAccess() {
    access = expr
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FunctionAddress and
    resultType = access.getType().getUnspecifiedType() and
    isGLValue = true
  }

  override Function getInstructionFunction(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = access.getTarget()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
}
