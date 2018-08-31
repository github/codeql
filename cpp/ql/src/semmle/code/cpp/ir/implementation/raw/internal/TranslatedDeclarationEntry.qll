import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedInitialization

/**
 * Gets the `TranslatedDeclarationEntry` that represents the declaration
 * `entry`.
 */
TranslatedDeclarationEntry getTranslatedDeclarationEntry(
  DeclarationEntry entry) {
  result.getAST() = entry
}

/**
 * Represents the IR translation of a declaration within the body of a function.
 * Most often, this is the declaration of an automatic local variable, although
 * it can also be the declaration of a static local variable, an extern
 * variable, or an extern function.
 */
abstract class TranslatedDeclarationEntry extends TranslatedElement,
  TTranslatedDeclarationEntry {
  DeclarationEntry entry;

  TranslatedDeclarationEntry() {
    this = TTranslatedDeclarationEntry(entry)
  }

  override final Function getFunction() {
    exists(DeclStmt stmt |
      stmt.getADeclarationEntry() = entry and
      result = stmt.getEnclosingFunction()
    )
  }

  override final string toString() {
    result = entry.toString()
  }

  override final Locatable getAST() {
    result = entry
  }
}

/**
 * Represents the IR translation of a declaration within the body of a function,
 * for declarations other than local variables. Since these have no semantic
 * effect, they are translated as `NoOp`.
 */
class TranslatedNonVariableDeclaration extends
  TranslatedDeclarationEntry {
  TranslatedNonVariableDeclaration() {
    not entry.getDeclaration() instanceof LocalVariable
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    opcode instanceof Opcode::NoOp and
    tag = OnlyInstructionTag() and
    resultType instanceof VoidType and
    isGLValue = false
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
}

/**
 * Represents the IR translation of the declaration of a local variable,
 * including its initialization, if any.
 */
abstract class TranslatedVariableDeclaration extends
  TranslatedDeclarationEntry {
  LocalVariable var;

  TranslatedVariableDeclaration() {
    entry.getDeclaration() = var
  }
}

/**
 * Represents the IR translation of a local variable with no initializer. The
 * generated IR stores into the variable using an `Uninitialized` instruction,
 * rather than a `Store`.
 */
class TranslatedUninitializedVariable extends
  TranslatedVariableDeclaration {
  TranslatedUninitializedVariable() {
    not exists(Initializer init |
      init.getDeclaration() = var
    )
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    (
      tag = InitializerVariableAddressTag() and
      opcode instanceof Opcode::VariableAddress and
      resultType = var.getType().getUnspecifiedType() and
      isGLValue = true
    ) or
    ( 
      tag = InitializerStoreTag() and
      opcode instanceof Opcode::Uninitialized and
      resultType = var.getType().getUnspecifiedType() and
      isGLValue = false
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = InitializerVariableAddressTag() and
        result = getInstruction(InitializerStoreTag())
      ) or
      (
        tag = InitializerStoreTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      (
        operandTag instanceof LoadStoreAddressOperand and
        result = getInstruction(InitializerVariableAddressTag())
      ) 
    )
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getIRUserVariable(var.getFunction(), var)
  }
}

/**
 * Represents the IR translation of a local variable with an initializer.
 */
class TranslatedInitializedVariable extends
  TranslatedVariableDeclaration, InitializationContext {
  Initializer init;

  TranslatedInitializedVariable() {
    init.getDeclaration() = var
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = var.getType().getUnspecifiedType() and
    isGLValue = true
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = InitializerVariableAddressTag() and
    result = getInitialization().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and result = getParent().getChildSuccessor(this)
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getIRUserVariable(var.getFunction(), var)
  }

  override Instruction getTargetAddress() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() {
    result = var.getType().getUnspecifiedType()
  }

  private TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(init.getExpr().getFullyConverted())
  }
}
