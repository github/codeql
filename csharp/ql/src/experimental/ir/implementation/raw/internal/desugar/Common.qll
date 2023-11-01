/**
 * Exposes several patterns for the compiler generated code, so as to improve code sharing between files that
 * deal with the desugaring process.
 * For example, we expose the `try ... finally` pattern, which is shared by the desugaring of both the
 * `ForeachStmt`, `UsingStmt` and `LockStmt`.
 */

import csharp
private import experimental.ir.implementation.Opcode
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.internal.CSharpType
private import experimental.ir.internal.TempVariableTag
private import experimental.ir.implementation.raw.internal.TranslatedElement
private import experimental.ir.implementation.raw.internal.TranslatedFunction
private import experimental.ir.implementation.raw.internal.InstructionTag
private import internal.TranslatedCompilerGeneratedStmt
private import internal.TranslatedCompilerGeneratedExpr
private import internal.TranslatedCompilerGeneratedCondition
private import internal.TranslatedCompilerGeneratedCall
private import internal.TranslatedCompilerGeneratedElement
private import internal.TranslatedCompilerGeneratedDeclaration
private import experimental.ir.implementation.raw.internal.common.TranslatedConditionBase
private import experimental.ir.implementation.raw.internal.common.TranslatedExprBase
private import experimental.ir.internal.IRCSharpLanguage as Language

/**
 * The general form of a compiler generated try stmt.
 * The concrete implementation needs to specify the body of the try and the
 * finally block.
 */
abstract class TranslatedCompilerGeneratedTry extends TranslatedCompilerGeneratedStmt {
  override Stmt generatedBy;

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override TranslatedElement getChild(int id) {
    id = 0 and result = this.getBody()
    or
    id = 1 and result = this.getFinally()
  }

  override Instruction getFirstInstruction() { result = this.getBody().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getBody() and result = this.getFinally().getFirstInstruction()
    or
    child = this.getFinally() and result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getExceptionSuccessorInstruction() {
    result = this.getParent().getExceptionSuccessorInstruction()
  }

  /**
   * Gets the finally block.
   */
  abstract TranslatedElement getFinally();

  /**
   * Gets the body of the try stmt.
   */
  abstract TranslatedElement getBody();
}

/**
 * The general form of a compiler generated constant expression.
 * The concrete implementation needs to specify the immediate operand that represents the constant.
 */
abstract class TranslatedCompilerGeneratedConstant extends TranslatedCompilerGeneratedExpr {
  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    opcode instanceof Opcode::Constant and
    tag = OnlyInstructionTag() and
    resultType = getTypeForPRValue(this.getResultType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getFirstInstruction() { result = this.getInstruction(OnlyInstructionTag()) }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

/**
 * The general form of a compiler generated block stmt.
 * The concrete implementation needs to specify the statements that
 * compose the block.
 */
abstract class TranslatedCompilerGeneratedBlock extends TranslatedCompilerGeneratedStmt {
  override TranslatedElement getChild(int id) { result = this.getStmt(id) }

  override Instruction getFirstInstruction() { result = this.getStmt(0).getFirstInstruction() }

  abstract TranslatedElement getStmt(int index);

  private int getStmtCount() { result = count(this.getStmt(_)) }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = this.getStmt(index) and
      if index = (this.getStmtCount() - 1)
      then result = this.getParent().getChildSuccessor(this)
      else result = this.getStmt(index + 1).getFirstInstruction()
    )
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }
}

/**
 * The general form of a compiler generated if stmt.
 * The concrete implementation needs to specify the condition,
 * the body of the `then` and the body of the `else`.
 */
abstract class TranslatedCompilerGeneratedIfStmt extends TranslatedCompilerGeneratedStmt,
  ConditionContext
{
  override Instruction getFirstInstruction() { result = this.getCondition().getFirstInstruction() }

  override TranslatedElement getChild(int id) {
    id = 0 and result = this.getCondition()
    or
    id = 1 and result = this.getThen()
    or
    id = 2 and result = this.getElse()
  }

  abstract TranslatedCompilerGeneratedValueCondition getCondition();

  abstract TranslatedCompilerGeneratedElement getThen();

  abstract TranslatedCompilerGeneratedElement getElse();

  private predicate hasElse() { exists(this.getElse()) }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildTrueSuccessor(ConditionBase child) {
    child = this.getCondition() and
    result = this.getThen().getFirstInstruction()
  }

  override Instruction getChildFalseSuccessor(ConditionBase child) {
    child = this.getCondition() and
    if this.hasElse()
    then result = this.getElse().getFirstInstruction()
    else result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (child = this.getThen() or child = this.getElse()) and
    result = this.getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }
}

/**
 * The general form of a compiler generated variable access.
 * The concrete implementation needs to specify the immediate
 * operand for the `VariableAddress` instruction and if the
 * access needs a `Load` instruction or not (eg. `ref` params do not)
 */
abstract class TranslatedCompilerGeneratedVariableAccess extends TranslatedCompilerGeneratedExpr {
  override Instruction getFirstInstruction() { result = this.getInstruction(AddressTag()) }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  /**
   * Returns the type of the accessed variable. Can be overridden when the return
   * type is different than the type of the underlying variable.
   */
  Type getVariableType() { result = this.getResultType() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = AddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(this.getVariableType())
    or
    this.needsLoad() and
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(this.getVariableType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    this.needsLoad() and
    tag = LoadTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
    or
    (
      tag = AddressTag() and
      kind instanceof GotoEdge and
      if this.needsLoad()
      then result = this.getInstruction(LoadTag())
      else result = this.getParent().getChildSuccessor(this)
    )
  }

  override Instruction getResult() {
    if this.needsLoad()
    then result = this.getInstruction(LoadTag())
    else result = this.getInstruction(AddressTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    this.needsLoad() and
    tag = LoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(AddressTag())
  }

  /**
   * Holds if the variable access should be followed by a `Load` instruction.
   */
  abstract predicate needsLoad();
}
