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
    id = 0 and result = getBody()
    or
    id = 1 and result = getFinally()
  }

  override Instruction getFirstInstruction() { result = getBody().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getBody() and result = getFinally().getFirstInstruction()
    or
    child = getFinally() and result = getParent().getChildSuccessor(this)
  }

  override Instruction getExceptionSuccessorInstruction() {
    result = getParent().getExceptionSuccessorInstruction()
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
    resultType = getTypeForPRValue(getResultType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getParent().getChildSuccessor(this)
  }

  override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

/**
 * The general form of a compiler generated block stmt.
 * The concrete implementation needs to specify the statements that
 * compose the block.
 */
abstract class TranslatedCompilerGeneratedBlock extends TranslatedCompilerGeneratedStmt {
  override TranslatedElement getChild(int id) { result = getStmt(id) }

  override Instruction getFirstInstruction() { result = getStmt(0).getFirstInstruction() }

  abstract TranslatedElement getStmt(int index);

  private int getStmtCount() { result = count(getStmt(_)) }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = getStmt(index) and
      if index = (getStmtCount() - 1)
      then result = getParent().getChildSuccessor(this)
      else result = getStmt(index + 1).getFirstInstruction()
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
  ConditionContext {
  override Instruction getFirstInstruction() { result = getCondition().getFirstInstruction() }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getCondition()
    or
    id = 1 and result = getThen()
    or
    id = 2 and result = getElse()
  }

  abstract TranslatedCompilerGeneratedValueCondition getCondition();

  abstract TranslatedCompilerGeneratedElement getThen();

  abstract TranslatedCompilerGeneratedElement getElse();

  private predicate hasElse() { exists(getElse()) }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildTrueSuccessor(ConditionBase child) {
    child = getCondition() and
    result = getThen().getFirstInstruction()
  }

  override Instruction getChildFalseSuccessor(ConditionBase child) {
    child = getCondition() and
    if hasElse()
    then result = getElse().getFirstInstruction()
    else result = getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (child = getThen() or child = getElse()) and
    result = getParent().getChildSuccessor(this)
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
  override Instruction getFirstInstruction() { result = getInstruction(AddressTag()) }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  /**
   * Returns the type of the accessed variable. Can be overriden when the return
   * type is different than the type of the underlying variable.
   */
  Type getVariableType() { result = getResultType() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = AddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(getVariableType())
    or
    needsLoad() and
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(getVariableType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    needsLoad() and
    tag = LoadTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
    or
    (
      tag = AddressTag() and
      kind instanceof GotoEdge and
      if needsLoad()
      then result = getInstruction(LoadTag())
      else result = getParent().getChildSuccessor(this)
    )
  }

  override Instruction getResult() {
    if needsLoad()
    then result = getInstruction(LoadTag())
    else result = getInstruction(AddressTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    needsLoad() and
    tag = LoadTag() and
    operandTag instanceof AddressOperandTag and
    result = getInstruction(AddressTag())
  }

  /**
   * Holds if the variable access should be followed by a `Load` instruction.
   */
  abstract predicate needsLoad();
}
