private import cpp
private import semmle.code.cpp.ir.internal.IRUtilities
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedDeclarationEntry
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction
private import TranslatedInitialization

TranslatedStmt getTranslatedStmt(Stmt stmt) { result.getAst() = stmt }

TranslatedMicrosoftTryExceptHandler getTranslatedMicrosoftTryExceptHandler(
  MicrosoftTryExceptStmt tryExcept
) {
  result.getAst() = tryExcept.getExcept()
}

class TranslatedMicrosoftTryExceptHandler extends TranslatedElement,
  TTranslatedMicrosoftTryExceptHandler
{
  MicrosoftTryExceptStmt tryExcept;

  TranslatedMicrosoftTryExceptHandler() { this = TTranslatedMicrosoftTryExceptHandler(tryExcept) }

  final override string toString() { result = tryExcept.toString() }

  final override Locatable getAst() { result = tryExcept.getExcept() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getChild(0).getFirstInstruction(kind)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    // t1 = -1
    tag = TryExceptGenerateNegativeOne() and
    opcode instanceof Opcode::Constant and
    resultType = getIntType()
    or
    // t2 = cmp t1, condition
    tag = TryExceptCompareNegativeOne() and
    opcode instanceof Opcode::CompareEQ and
    resultType = getBoolType()
    or
    // if t2 goto ... else goto ...
    tag = TryExceptCompareNegativeOneBranch() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType = getVoidType()
    or
    // t1 = 0
    tag = TryExceptGenerateZero() and
    opcode instanceof Opcode::Constant and
    resultType = getIntType()
    or
    // t2 = cmp t1, condition
    tag = TryExceptCompareZero() and
    opcode instanceof Opcode::CompareEQ and
    resultType = getBoolType()
    or
    // if t2 goto ... else goto ...
    tag = TryExceptCompareZeroBranch() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType = getVoidType()
    or
    // t1 = 1
    tag = TryExceptGenerateOne() and
    opcode instanceof Opcode::Constant and
    resultType = getIntType()
    or
    // t2 = cmp t1, condition
    tag = TryExceptCompareOne() and
    opcode instanceof Opcode::CompareEQ and
    resultType = getBoolType()
    or
    // if t2 goto ... else goto ...
    tag = TryExceptCompareOneBranch() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType = getVoidType()
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = TryExceptCompareNegativeOne() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getTranslatedCondition().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(TryExceptGenerateNegativeOne())
    )
    or
    tag = TryExceptCompareNegativeOneBranch() and
    operandTag instanceof ConditionOperandTag and
    result = this.getInstruction(TryExceptCompareNegativeOne())
    or
    tag = TryExceptCompareZero() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getTranslatedCondition().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(TryExceptGenerateZero())
    )
    or
    tag = TryExceptCompareZeroBranch() and
    operandTag instanceof ConditionOperandTag and
    result = this.getInstruction(TryExceptCompareZero())
    or
    tag = TryExceptCompareOne() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getTranslatedCondition().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(TryExceptGenerateOne())
    )
    or
    tag = TryExceptCompareOneBranch() and
    operandTag instanceof ConditionOperandTag and
    result = this.getInstruction(TryExceptCompareOne())
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = TryExceptGenerateNegativeOne() and
    result = "-1"
    or
    tag = TryExceptGenerateZero() and
    result = "0"
    or
    tag = TryExceptGenerateOne() and
    result = "1"
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    // Generate -1 -> Compare condition
    tag = TryExceptGenerateNegativeOne() and
    kind instanceof GotoEdge and
    result = this.getInstruction(TryExceptCompareNegativeOne())
    or
    // Compare condition -> Branch
    tag = TryExceptCompareNegativeOne() and
    kind instanceof GotoEdge and
    result = this.getInstruction(TryExceptCompareNegativeOneBranch())
    or
    // Branch -> Unwind or Generate 0
    tag = TryExceptCompareNegativeOneBranch() and
    (
      kind instanceof TrueEdge and
      // TODO: This is not really correct. The semantics of `EXCEPTION_CONTINUE_EXECUTION` is that
      // we should continue execution at the point where the exception occurred. But we don't have
      // any instruction to model this behavior.
      result = this.getExceptionSuccessorInstruction(any(GotoEdge edge))
      or
      kind instanceof FalseEdge and
      result = this.getInstruction(TryExceptGenerateZero())
    )
    or
    // Generate 0 -> Compare condition
    tag = TryExceptGenerateZero() and
    kind instanceof GotoEdge and
    result = this.getInstruction(TryExceptCompareZero())
    or
    // Compare condition -> Branch
    tag = TryExceptCompareZero() and
    kind instanceof GotoEdge and
    result = this.getInstruction(TryExceptCompareZeroBranch())
    or
    // Branch -> Unwind or Generate 1
    tag = TryExceptCompareZeroBranch() and
    (
      kind instanceof TrueEdge and
      result = this.getExceptionSuccessorInstruction(any(GotoEdge edge))
      or
      kind instanceof FalseEdge and
      result = this.getInstruction(TryExceptGenerateOne())
    )
    or
    // Generate 1 -> Compare condition
    tag = TryExceptGenerateOne() and
    kind instanceof GotoEdge and
    result = this.getInstruction(TryExceptCompareOne())
    or
    // Compare condition -> Branch
    tag = TryExceptCompareOne() and
    kind instanceof GotoEdge and
    result = this.getInstruction(TryExceptCompareOneBranch())
    or
    // Branch -> Handler (the condition value is always 0, -1 or 1, and we've checked for 0 or -1 already.)
    tag = TryExceptCompareOneBranch() and
    kind instanceof TrueEdge and
    result = this.getTranslatedHandler().getFirstInstruction(any(GotoEdge edge))
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    kind instanceof GotoEdge and
    child = this.getTranslatedCondition() and
    result = this.getInstruction(TryExceptGenerateNegativeOne())
    or
    child = this.getTranslatedHandler() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override TranslatedElement getLastChild() { result = this.getTranslatedHandler() }

  override Instruction getALastInstructionInternal() {
    result = this.getTranslatedHandler().getALastInstruction()
  }

  private TranslatedExpr getTranslatedCondition() {
    result = getTranslatedExpr(tryExcept.getCondition())
  }

  private TranslatedStmt getTranslatedHandler() {
    result = getTranslatedStmt(tryExcept.getExcept())
  }

  override TranslatedElement getChild(int id) {
    id = 0 and
    result = this.getTranslatedCondition()
    or
    id = 1 and
    result = this.getTranslatedHandler()
  }

  final override Function getFunction() { result = tryExcept.getEnclosingFunction() }

  override Instruction getExceptionSuccessorInstruction(EdgeKind kind) {
    // A throw from within a `__except` block flows to the handler for the parent of
    // the `__try`.
    result = this.getParent().getParent().getExceptionSuccessorInstruction(kind)
  }
}

TranslatedMicrosoftTryFinallyHandler getTranslatedMicrosoftTryFinallyHandler(
  MicrosoftTryFinallyStmt tryFinally
) {
  result.getAst() = tryFinally.getFinally()
}

class TranslatedMicrosoftTryFinallyHandler extends TranslatedElement,
  TTranslatedMicrosoftTryFinallyHandler
{
  MicrosoftTryFinallyStmt tryFinally;

  TranslatedMicrosoftTryFinallyHandler() {
    this = TTranslatedMicrosoftTryFinallyHandler(tryFinally)
  }

  final override string toString() { result = tryFinally.toString() }

  final override Locatable getAst() { result = tryFinally.getFinally() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getTranslatedFinally().getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getTranslatedFinally().getALastInstruction()
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getTranslatedFinally() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override TranslatedElement getChild(int id) {
    id = 0 and
    result = this.getTranslatedFinally()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Function getFunction() { result = tryFinally.getEnclosingFunction() }

  private TranslatedStmt getTranslatedFinally() {
    result = getTranslatedStmt(tryFinally.getFinally())
  }

  override Instruction getExceptionSuccessorInstruction(EdgeKind kind) {
    // A throw from within a `__finally` block flows to the handler for the parent of
    // the `__try`.
    result = this.getParent().getParent().getExceptionSuccessorInstruction(kind)
  }
}

abstract class TranslatedStmt extends TranslatedElement, TTranslatedStmt {
  Stmt stmt;

  TranslatedStmt() { this = TTranslatedStmt(stmt) }

  abstract TranslatedElement getChildInternal(int id);

  final override TranslatedElement getChild(int id) {
    result = this.getChildInternal(id)
    or
    exists(int destructorIndex |
      result.(TranslatedExpr).getExpr() = stmt.getImplicitDestructorCall(destructorIndex) and
      id = this.getFirstDestructorCallIndex() + destructorIndex
    )
  }

  final override int getFirstDestructorCallIndex() {
    result = max(int childId | exists(this.getChildInternal(childId))) + 1
    or
    not exists(this.getChildInternal(_)) and result = 0
  }

  final override predicate hasAnImplicitDestructorCall() {
    exists(stmt.getAnImplicitDestructorCall())
  }

  final override string toString() { result = stmt.toString() }

  final override Locatable getAst() { result = stmt }

  final override Function getFunction() { result = stmt.getEnclosingFunction() }
}

class TranslatedEmptyStmt extends TranslatedStmt {
  TranslatedEmptyStmt() {
    stmt instanceof EmptyStmt or
    stmt instanceof LabelStmt or
    stmt instanceof SwitchCase
  }

  override TranslatedElement getChildInternal(int id) { none() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(OnlyInstructionTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) { none() }
}

/**
 * The IR translation of a declaration statement. This consists of the IR for each of the individual
 * local variables declared by the statement. Declarations for extern variables and functions
 * do not generate any instructions.
 */
class TranslatedDeclStmt extends TranslatedStmt {
  override DeclStmt stmt;

  override TranslatedElement getChildInternal(int id) { result = this.getDeclarationEntry(id) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getDeclarationEntry(0).getFirstInstruction(kind)
    or
    not exists(this.getDeclarationEntry(0)) and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getChild(this.getChildCount() - 1).getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getChild(this.getChildCount() - 1) }

  private int getChildCount() { result = count(this.getDeclarationEntry(_)) }

  IRDeclarationEntry getIRDeclarationEntry(int index) {
    result.hasIndex(index) and
    result.getStmt() = stmt
  }

  IRDeclarationEntry getAnIRDeclarationEntry() { result = this.getIRDeclarationEntry(_) }

  /**
   * Gets the `TranslatedDeclarationEntry` child at zero-based index `index`. Since not all
   * `DeclarationEntry` objects have a `TranslatedDeclarationEntry` (e.g. extern functions), we map
   * the original children into a contiguous range containing only those with an actual
   * `TranslatedDeclarationEntry`.
   */
  private TranslatedDeclarationEntry getDeclarationEntry(int index) {
    result =
      rank[index + 1](TranslatedDeclarationEntry entry, int originalIndex |
        entry = getTranslatedDeclarationEntry(this.getIRDeclarationEntry(originalIndex))
      |
        entry order by originalIndex
      )
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    exists(int index |
      child = this.getDeclarationEntry(index) and
      if index = (this.getChildCount() - 1)
      then result = this.getParent().getChildSuccessor(this, kind)
      else result = this.getDeclarationEntry(index + 1).getFirstInstruction(kind)
    )
  }
}

class TranslatedExprStmt extends TranslatedStmt {
  override ExprStmt stmt;

  TranslatedExpr getExpr() { result = getTranslatedExpr(stmt.getExpr().getFullyConverted()) }

  override TranslatedElement getChildInternal(int id) { id = 0 and result = this.getExpr() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getExpr().getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getExpr().getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getExpr() }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getExpr() and
    result = this.getParent().getChildSuccessor(this, kind)
  }
}

abstract class TranslatedReturnStmt extends TranslatedStmt {
  override ReturnStmt stmt;

  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(stmt.getEnclosingFunction())
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    exists(int id |
      child = this.getChild(id) and
      id >= this.getFirstDestructorCallIndex() and
      (
        result = this.getChild(id + 1).getFirstInstruction(kind)
        or
        not exists(this.getChild(id + 1)) and
        result = this.getEnclosingFunction().getReturnSuccessorInstruction(kind)
      )
    )
  }

  final override predicate handlesDestructorsExplicitly() { any() }
}

/**
 * The IR translation of a `return` statement that returns a value.
 */
class TranslatedReturnValueStmt extends TranslatedReturnStmt, TranslatedVariableInitialization {
  TranslatedReturnValueStmt() { stmt.hasExpr() and hasReturnValue(stmt.getEnclosingFunction()) }

  final override Instruction getInitializationSuccessor(EdgeKind kind) {
    if this.hasAnImplicitDestructorCall()
    then result = this.getChild(1).getFirstInstruction(kind)
    else result = this.getEnclosingFunction().getReturnSuccessorInstruction(kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    result = TranslatedVariableInitialization.super.getChildSuccessorInternal(child, kind)
    or
    result = TranslatedReturnStmt.super.getChildSuccessorInternal(child, kind)
  }

  final override TranslatedElement getChildInternal(int id) {
    result = TranslatedVariableInitialization.super.getChildInternal(id)
  }

  final override Type getTargetType() { result = this.getEnclosingFunction().getReturnType() }

  final override TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(stmt.getExpr().getFullyConverted())
  }

  final override IRVariable getIRVariable() {
    result = this.getEnclosingFunction().getReturnVariable()
  }
}

/**
 * The IR translation of a `return` statement that returns an expression of `void` type.
 */
class TranslatedReturnVoidExpressionStmt extends TranslatedReturnStmt {
  TranslatedReturnVoidExpressionStmt() {
    stmt.hasExpr() and not hasReturnValue(stmt.getEnclosingFunction())
  }

  override TranslatedElement getChildInternal(int id) {
    id = 0 and
    result = this.getExpr()
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getExpr().getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    if this.hasAnImplicitDestructorCall()
    then result = this.getChild(max(int id | exists(this.getChild(id)))).getALastInstruction()
    else result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    if this.hasAnImplicitDestructorCall()
    then result = this.getChild(1).getFirstInstruction(kind)
    else result = this.getEnclosingFunction().getReturnSuccessorInstruction(kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getExpr() and
    result = this.getInstruction(OnlyInstructionTag()) and
    kind instanceof GotoEdge
    or
    result = TranslatedReturnStmt.super.getChildSuccessorInternal(child, kind)
  }

  private TranslatedExpr getExpr() { result = getTranslatedExpr(stmt.getExpr()) }
}

/**
 * The IR translation of a `return` statement that does not return a value. This includes implicit
 * return statements at the end of `void`-returning functions.
 */
class TranslatedReturnVoidStmt extends TranslatedReturnStmt {
  TranslatedReturnVoidStmt() {
    not stmt.hasExpr() and not hasReturnValue(stmt.getEnclosingFunction())
  }

  override TranslatedElement getChildInternal(int id) { none() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(OnlyInstructionTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    if this.hasAnImplicitDestructorCall()
    then result = this.getChild(max(int id | exists(this.getChild(id)))).getALastInstruction()
    else result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    if this.hasAnImplicitDestructorCall()
    then result = this.getChild(0).getFirstInstruction(kind)
    else result = this.getEnclosingFunction().getReturnSuccessorInstruction(kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    exists(int id |
      this.getChild(id) = child and
      (
        result = this.getChild(id + 1).getFirstInstruction(kind)
        or
        not exists(this.getChild(id + 1)) and
        result = this.getEnclosingFunction().getReturnSuccessorInstruction(kind)
      )
    )
  }
}

/**
 * The IR translation of an implicit `return` statement generated by the extractor to handle control
 * flow that reaches the end of a non-`void`-returning function body. Such control flow
 * produces undefined behavior in C++ but not in C. However even in C using the return value is
 * undefined behaviour. We make it return uninitialized memory to get as much flow as possible.
 */
class TranslatedNoValueReturnStmt extends TranslatedReturnStmt, TranslatedVariableInitialization {
  TranslatedNoValueReturnStmt() {
    not stmt.hasExpr() and hasReturnValue(stmt.getEnclosingFunction())
  }

  final override Instruction getInitializationSuccessor(EdgeKind kind) {
    result = this.getEnclosingFunction().getReturnSuccessorInstruction(kind)
  }

  final override TranslatedElement getChildInternal(int id) {
    result = TranslatedVariableInitialization.super.getChildInternal(id)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    result = TranslatedVariableInitialization.super.getChildSuccessorInternal(child, kind)
    or
    result = TranslatedReturnStmt.super.getChildSuccessorInternal(child, kind)
  }

  final override Type getTargetType() { result = this.getEnclosingFunction().getReturnType() }

  final override TranslatedInitialization getInitialization() { none() }

  final override IRVariable getIRVariable() {
    result = this.getEnclosingFunction().getReturnVariable()
  }
}

/**
 * A C/C++ `try` statement, or a `__try __except` or `__try __finally` statement.
 */
class TryOrMicrosoftTryStmt extends Stmt {
  TryOrMicrosoftTryStmt() {
    this instanceof TryStmt or
    this instanceof MicrosoftTryStmt
  }

  /** Gets the number of `catch block`s of this statement. */
  int getNumberOfCatchClauses() {
    result = this.(TryStmt).getNumberOfCatchClauses()
    or
    this instanceof MicrosoftTryExceptStmt and
    result = 1
    or
    this instanceof MicrosoftTryFinallyStmt and
    result = 0
  }

  /** Gets the `body` statement of this statement. */
  Stmt getStmt() {
    result = this.(TryStmt).getStmt()
    or
    result = this.(MicrosoftTryStmt).getStmt()
  }

  /** Gets the `i`th translated handler of this statement. */
  TranslatedElement getTranslatedHandler(int index) {
    result = getTranslatedStmt(this.(TryStmt).getChild(index + 1))
    or
    index = 0 and
    result = getTranslatedMicrosoftTryExceptHandler(this)
  }

  /** Gets the `finally` statement (usually a BlockStmt), if any. */
  TranslatedElement getTranslatedFinally() {
    result = getTranslatedMicrosoftTryFinallyHandler(this)
  }
}

/**
 * The IR translation of a C++ `try` (or a `__try __except` or `__try __finally`) statement.
 */
class TranslatedTryStmt extends TranslatedStmt {
  override TryOrMicrosoftTryStmt stmt;

  override TranslatedElement getChildInternal(int id) {
    id = 0 and result = this.getBody()
    or
    result = this.getHandler(id - 1)
    or
    id = stmt.getNumberOfCatchClauses() + 1 and
    result = this.getFinally()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getBody().getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getLastChild().getALastInstruction()
  }

  override TranslatedElement getLastChild() {
    if exists(this.getFinally())
    then result = this.getFinally()
    else result = [this.getBody(), this.getHandler(_)]
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    // All non-finally children go to the successor of the `try` if
    // there is no finally block, but if there is a finally block
    // then we go to that one.
    child = [this.getBody(), this.getHandler(_)] and
    (
      not exists(this.getFinally()) and
      result = this.getParent().getChildSuccessor(this, kind)
      or
      result = this.getFinally().getFirstInstruction(kind)
    )
    or
    // And after the finally block we go to the successor of the `try`.
    child = this.getFinally() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  final Instruction getNextHandler(TranslatedHandler handler, EdgeKind kind) {
    exists(int index |
      handler = this.getHandler(index) and
      result = this.getHandler(index + 1).getFirstInstruction(kind)
    )
    or
    // The last catch clause flows to the exception successor of the parent
    // of the `try`, because the exception successor of the `try` itself is
    // the first catch clause.
    handler = this.getHandler(stmt.getNumberOfCatchClauses() - 1) and
    result = this.getParent().getExceptionSuccessorInstruction(kind)
  }

  final override Instruction getExceptionSuccessorInstruction(EdgeKind kind) {
    result = this.getHandler(0).getFirstInstruction(kind)
    or
    not exists(this.getHandler(_)) and
    result = this.getFinally().getFirstInstruction(kind)
  }

  private TranslatedElement getHandler(int index) { result = stmt.getTranslatedHandler(index) }

  private TranslatedElement getFinally() { result = stmt.getTranslatedFinally() }

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getStmt()) }
}

class TranslatedBlock extends TranslatedStmt {
  override BlockStmt stmt;

  override TranslatedElement getChildInternal(int id) { result = this.getStmt(id) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    this.isEmpty() and
    opcode instanceof Opcode::NoOp and
    tag = OnlyInstructionTag() and
    resultType = getVoidType()
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    if this.isEmpty()
    then kind instanceof GotoEdge and result = this.getInstruction(OnlyInstructionTag())
    else result = this.getStmt(0).getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    if this.isEmpty()
    then result = this.getInstruction(OnlyInstructionTag())
    else result = this.getStmt(this.getStmtCount() - 1).getFirstInstruction(any(GotoEdge goto))
  }

  override TranslatedElement getLastChild() { result = this.getStmt(this.getStmtCount() - 1) }

  private predicate isEmpty() { not exists(stmt.getStmt(0)) }

  private TranslatedStmt getStmt(int index) { result = getTranslatedStmt(stmt.getStmt(index)) }

  private int getStmtCount() { result = stmt.getNumStmt() }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    exists(int index |
      child = this.getStmt(index) and
      if index = (this.getStmtCount() - 1)
      then result = this.getParent().getChildSuccessor(this, kind)
      else result = this.getStmt(index + 1).getFirstInstruction(kind)
    )
  }
}

/**
 * The IR translation of a C++ `catch` handler.
 */
abstract class TranslatedHandler extends TranslatedStmt {
  override Handler stmt;

  override TranslatedElement getChildInternal(int id) { id = 1 and result = this.getBlock() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(CatchTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    result = this.getBlock().getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getBlock() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getBlock() and result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getExceptionSuccessorInstruction(EdgeKind kind) {
    // A throw from within a `catch` block flows to the handler for the parent of
    // the `try`.
    result = this.getParent().getParent().getExceptionSuccessorInstruction(kind)
  }

  TranslatedStmt getBlock() { result = getTranslatedStmt(stmt.getBlock()) }
}

/**
 * The IR translation of the destructor calls of the parent `TranslatedCatchByTypeHandler`.
 *
 * This object does not itself generate the destructor calls. Instead, its
 * children provide the actual calls.
 */
class TranslatedDestructorsAfterHandler extends TranslatedElement,
  TTranslatedDestructorsAfterHandler
{
  Handler handler;

  TranslatedDestructorsAfterHandler() { this = TTranslatedDestructorsAfterHandler(handler) }

  override string toString() { result = "Destructor calls after handler: " + handler }

  private TranslatedCall getTranslatedImplicitDestructorCall(int id) {
    result.getExpr() = handler.getImplicitDestructorCall(id)
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getChild(0).getFirstInstruction(kind)
  }

  override Handler getAst() { result = handler }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override TranslatedElement getChild(int id) {
    result = this.getTranslatedImplicitDestructorCall(id)
  }

  override predicate handlesDestructorsExplicitly() { any() }

  override Declaration getFunction() { result = handler.getEnclosingFunction() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    exists(int id | child = this.getChild(id) |
      // Transition to the next child, if any.
      result = this.getChild(id + 1).getFirstInstruction(kind)
      or
      // And otherwise go to the next handler, if any.
      not exists(this.getChild(id + 1)) and
      result =
        getTranslatedStmt(handler)
            .getParent()
            .(TranslatedTryStmt)
            .getNextHandler(getTranslatedStmt(handler), kind)
    )
  }

  override TranslatedElement getLastChild() {
    result =
      this.getTranslatedImplicitDestructorCall(max(int id |
          exists(handler.getImplicitDestructorCall(id))
        ))
  }

  override Instruction getALastInstructionInternal() {
    result = this.getLastChild().getALastInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }
}

/**
 * The IR translation of a C++ `catch` block that catches an exception with a
 * specific type (e.g. `catch (const std::exception&)`).
 */
class TranslatedCatchByTypeHandler extends TranslatedHandler {
  TranslatedCatchByTypeHandler() { exists(stmt.getParameter()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = CatchTag() and
    opcode instanceof Opcode::CatchByType and
    resultType = getVoidType()
  }

  override predicate handlesDestructorsExplicitly() { any() }

  override TranslatedElement getChildInternal(int id) {
    result = super.getChildInternal(id)
    or
    id = 0 and result = this.getParameter()
    or
    id = 1 and result = this.getDestructors()
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    result = super.getChildSuccessorInternal(child, kind)
    or
    child = this.getParameter() and
    result = this.getBlock().getFirstInstruction(kind)
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = CatchTag() and
    (
      kind instanceof GotoEdge and
      result = this.getParameter().getFirstInstruction(kind)
      or
      kind instanceof CppExceptionEdge and
      if exists(this.getDestructors())
      then result = this.getDestructors().getFirstInstruction(any(GotoEdge edge))
      else result = this.getParent().(TranslatedTryStmt).getNextHandler(this, any(GotoEdge edge))
    )
  }

  override CppType getInstructionExceptionType(InstructionTag tag) {
    tag = CatchTag() and
    result = getTypeForPRValue(stmt.getParameter().getType())
  }

  private TranslatedParameter getParameter() {
    result = getTranslatedParameter(stmt.getParameter())
  }

  private TranslatedDestructorsAfterHandler getDestructors() { result.getAst() = stmt }
}

/**
 * The IR translation of a C++ `catch (...)` block.
 */
class TranslatedCatchAnyHandler extends TranslatedHandler {
  TranslatedCatchAnyHandler() { not exists(stmt.getParameter()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = CatchTag() and
    opcode instanceof Opcode::CatchAny and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = CatchTag() and
    result = this.getBlock().getFirstInstruction(kind)
  }
}

abstract class TranslatedIfLikeStmt extends TranslatedStmt, ConditionContext {
  override Instruction getFirstInstruction(EdgeKind kind) {
    if this.hasInitialization()
    then result = this.getInitialization().getFirstInstruction(kind)
    else result = this.getFirstConditionInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getElse().getALastInstruction() or result = this.getThen().getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getElse() or result = this.getThen() }

  override predicate handlesDestructorsExplicitly() { any() }

  override TranslatedElement getChildInternal(int id) {
    id = 0 and result = this.getInitialization()
    or
    id = 1 and result = this.getCondition()
    or
    id = 2 and result = this.getThen()
    or
    id = 3 and result = this.getElse()
  }

  abstract predicate hasInitialization();

  abstract TranslatedStmt getInitialization();

  abstract TranslatedCondition getCondition();

  private Instruction getFirstConditionInstruction(EdgeKind kind) {
    result = this.getCondition().getFirstInstruction(kind)
  }

  abstract TranslatedStmt getThen();

  abstract TranslatedStmt getElse();

  abstract predicate hasElse();

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildTrueSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getCondition() and
    result = this.getThen().getFirstInstruction(kind)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getCondition() and
    if this.hasElse()
    then result = this.getElse().getFirstInstruction(kind)
    else (
      if this.hasAnImplicitDestructorCall()
      then result = this.getChild(this.getFirstDestructorCallIndex()).getFirstInstruction(kind)
      else result = this.getParent().getChildSuccessor(this, kind)
    )
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitialization() and
    result = this.getFirstConditionInstruction(kind)
    or
    (child = this.getThen() or child = this.getElse()) and
    (
      if this.hasAnImplicitDestructorCall()
      then result = this.getChild(this.getFirstDestructorCallIndex()).getFirstInstruction(kind)
      else result = this.getParent().getChildSuccessor(this, kind)
    )
    or
    exists(int destructorId |
      destructorId >= this.getFirstDestructorCallIndex() and
      child = this.getChild(destructorId) and
      result = this.getChild(destructorId + 1).getFirstInstruction(kind)
    )
    or
    exists(int lastDestructorIndex |
      lastDestructorIndex =
        max(int n | exists(this.getChild(n)) and n >= this.getFirstDestructorCallIndex()) and
      child = this.getChild(lastDestructorIndex) and
      result = this.getParent().getChildSuccessor(this, kind)
    )
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }
}

class TranslatedIfStmt extends TranslatedIfLikeStmt {
  override IfStmt stmt;

  override predicate hasInitialization() { exists(stmt.getInitialization()) }

  override TranslatedStmt getInitialization() {
    result = getTranslatedStmt(stmt.getInitialization())
  }

  override TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  override TranslatedStmt getThen() { result = getTranslatedStmt(stmt.getThen()) }

  override TranslatedStmt getElse() { result = getTranslatedStmt(stmt.getElse()) }

  override predicate hasElse() { exists(stmt.getElse()) }
}

class TranslatedConstExprIfStmt extends TranslatedIfLikeStmt {
  override ConstexprIfStmt stmt;

  override predicate hasInitialization() { exists(stmt.getInitialization()) }

  override TranslatedStmt getInitialization() {
    result = getTranslatedStmt(stmt.getInitialization())
  }

  override TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  override TranslatedStmt getThen() { result = getTranslatedStmt(stmt.getThen()) }

  override TranslatedStmt getElse() { result = getTranslatedStmt(stmt.getElse()) }

  override predicate hasElse() { exists(stmt.getElse()) }
}

class TranslatedConstevalIfStmt extends TranslatedStmt {
  override ConstevalIfStmt stmt;

  override Instruction getFirstInstruction(EdgeKind kind) {
    if not this.hasEvaluatedBranch()
    then
      kind instanceof GotoEdge and
      result = this.getInstruction(OnlyInstructionTag())
    else result = this.getEvaluatedBranch().getFirstInstruction(kind)
  }

  override TranslatedElement getChildInternal(int id) {
    id = 0 and
    result = this.getThen()
    or
    id = 1 and
    result = this.getElse()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    not this.hasEvaluatedBranch() and
    opcode instanceof Opcode::NoOp and
    tag = OnlyInstructionTag() and
    resultType = getVoidType()
  }

  override Instruction getALastInstructionInternal() {
    if not this.hasEvaluatedBranch()
    then result = this.getInstruction(OnlyInstructionTag())
    else result = this.getEvaluatedBranch().getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getEvaluatedBranch() }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    (child = this.getThen() or child = this.getElse()) and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  TranslatedStmt getEvaluatedBranch() {
    result = getTranslatedStmt(stmt.getRuntimeEvaluatedBranch())
  }

  predicate hasEvaluatedBranch() { stmt.hasRuntimeEvaluatedBranch() }

  TranslatedStmt getThen() { result = getTranslatedStmt(stmt.getThen()) }

  TranslatedStmt getElse() { result = getTranslatedStmt(stmt.getElse()) }
}

abstract class TranslatedLoop extends TranslatedStmt, ConditionContext {
  override Loop stmt;

  override Instruction getALastInstructionInternal() {
    result = this.getCondition().getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getCondition() }

  final TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  final TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getStmt()) }

  final Instruction getFirstConditionInstruction(EdgeKind kind) {
    if this.hasCondition()
    then result = this.getCondition().getFirstInstruction(kind)
    else result = this.getBody().getFirstInstruction(kind)
  }

  final predicate hasCondition() { exists(stmt.getCondition()) }

  override TranslatedElement getChildInternal(int id) {
    id = 0 and result = this.getCondition()
    or
    id = 1 and result = this.getBody()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    none()
  }

  final override Instruction getChildTrueSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getCondition() and result = this.getBody().getFirstInstruction(kind)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getCondition() and
    result = this.getParent().getChildSuccessor(this, kind)
  }
}

class TranslatedWhileStmt extends TranslatedLoop {
  TranslatedWhileStmt() { stmt instanceof WhileStmt }

  override TranslatedElement getChildInternal(int id) {
    id = 0 and result = this.getCondition()
    or
    id = 1 and result = this.getBody()
    or
    exists(int n |
      result.getAst() = stmt.getImplicitDestructorCall(n) and
      id = 2 + n
    )
  }

  override predicate handlesDestructorsExplicitly() { any() }

  final override Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getCondition() and
    if this.hasAnImplicitDestructorCall()
    then result = this.getChild(this.getFirstDestructorCallIndex()).getFirstInstruction(kind)
    else result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getFirstConditionInstruction(kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getBody() and
    result = this.getFirstConditionInstruction(kind)
    or
    child = this.getChild(this.getFirstDestructorCallIndex()) and
    result = this.getParent().getChildSuccessor(this, kind)
  }
}

class TranslatedDoStmt extends TranslatedLoop {
  TranslatedDoStmt() { stmt instanceof DoStmt }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getBody().getFirstInstruction(kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getBody() and
    result = this.getFirstConditionInstruction(kind)
  }
}

class TranslatedForStmt extends TranslatedLoop {
  override ForStmt stmt;

  override predicate handlesDestructorsExplicitly() { any() }

  final override Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getCondition() and
    if this.hasAnImplicitDestructorCall()
    then result = this.getChild(this.getFirstDestructorCallIndex()).getFirstInstruction(kind)
    else result = this.getParent().getChildSuccessor(this, kind)
  }

  override TranslatedElement getChildInternal(int id) {
    id = 0 and result = this.getInitialization()
    or
    id = 1 and result = this.getCondition()
    or
    id = 2 and result = this.getUpdate()
    or
    id = 3 and result = this.getBody()
    or
    exists(int n |
      result.getAst() = stmt.getImplicitDestructorCall(n) and
      id = 4 + n
    )
  }

  private TranslatedStmt getInitialization() {
    result = getTranslatedStmt(stmt.getInitialization())
  }

  private predicate hasInitialization() { exists(stmt.getInitialization()) }

  TranslatedExpr getUpdate() { result = getTranslatedExpr(stmt.getUpdate().getFullyConverted()) }

  private predicate hasUpdate() { exists(stmt.getUpdate()) }

  override Instruction getFirstInstruction(EdgeKind kind) {
    if this.hasInitialization()
    then result = this.getInitialization().getFirstInstruction(kind)
    else result = this.getFirstConditionInstruction(kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitialization() and
    result = this.getFirstConditionInstruction(kind)
    or
    (
      child = this.getBody() and
      if this.hasUpdate()
      then result = this.getUpdate().getFirstInstruction(kind)
      else result = this.getFirstConditionInstruction(kind)
    )
    or
    child = this.getUpdate() and result = this.getFirstConditionInstruction(kind)
    or
    exists(int destructorId |
      destructorId >= this.getFirstDestructorCallIndex() and
      child = this.getChild(destructorId) and
      result = this.getChild(destructorId + 1).getFirstInstruction(kind)
    )
    or
    exists(int lastDestructorIndex |
      lastDestructorIndex =
        max(int n | exists(this.getChild(n)) and n >= this.getFirstDestructorCallIndex()) and
      child = this.getChild(lastDestructorIndex) and
      result = this.getParent().getChildSuccessor(this, kind)
    )
  }
}

/**
 * The IR translation of a range-based `for` loop.
 * Note that this class does not extend `TranslatedLoop`. This is because the "body" of the
 * range-based `for` loop consists of the per-iteration variable declaration followed by the
 * user-written body statement. It is easier to handle the control flow of the loop separately,
 * rather than synthesizing a single body or complicating the interface of `TranslatedLoop`.
 */
class TranslatedRangeBasedForStmt extends TranslatedStmt, ConditionContext {
  override RangeBasedForStmt stmt;

  override predicate handlesDestructorsExplicitly() { any() }

  override TranslatedElement getChildInternal(int id) {
    id = 0 and result = this.getInitialization()
    or
    id = 1 and result = this.getRangeVariableDeclStmt()
    or
    // Note: `__begin` and `__end` are declared by the same `DeclStmt`
    id = 2 and result = this.getBeginEndVariableDeclStmt()
    or
    id = 3 and result = this.getCondition()
    or
    id = 4 and result = this.getUpdate()
    or
    id = 5 and result = this.getVariableDeclStmt()
    or
    id = 6 and result = this.getBody()
  }

  private predicate hasInitialization() { exists(stmt.getInitialization()) }

  private TranslatedStmt getInitialization() {
    result = getTranslatedStmt(stmt.getInitialization())
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    if this.hasInitialization()
    then result = this.getInitialization().getFirstInstruction(kind)
    else result = this.getFirstRangeVariableDeclStmtInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getCondition().getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getCondition() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitialization() and
    result = this.getFirstRangeVariableDeclStmtInstruction(kind)
    or
    child = this.getRangeVariableDeclStmt() and
    result = this.getBeginEndVariableDeclStmt().getFirstInstruction(kind)
    or
    child = this.getBeginEndVariableDeclStmt() and
    result = this.getCondition().getFirstInstruction(kind)
    or
    child = this.getVariableDeclStmt() and
    result = this.getBody().getFirstInstruction(kind)
    or
    child = this.getBody() and
    result = this.getUpdate().getFirstInstruction(kind)
    or
    child = this.getUpdate() and
    result = this.getCondition().getFirstInstruction(kind)
    or
    exists(int destructorId |
      destructorId >= this.getFirstDestructorCallIndex() and
      child = this.getChild(destructorId) and
      result = this.getChild(destructorId + 1).getFirstInstruction(kind)
    )
    or
    exists(int lastDestructorIndex |
      lastDestructorIndex =
        max(int n | exists(this.getChild(n)) and n >= this.getFirstDestructorCallIndex()) and
      child = this.getChild(lastDestructorIndex) and
      result = this.getParent().getChildSuccessor(this, kind)
    )
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildTrueSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getCondition() and
    result = this.getVariableDeclStmt().getFirstInstruction(kind)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getCondition() and
    if this.hasAnImplicitDestructorCall()
    then result = this.getChild(this.getFirstDestructorCallIndex()).getFirstInstruction(kind)
    else result = this.getParent().getChildSuccessor(this, kind)
  }

  private TranslatedDeclStmt getRangeVariableDeclStmt() {
    exists(IRVariableDeclarationEntry entry |
      entry.getDeclaration() = stmt.getRangeVariable() and
      result.getAnIRDeclarationEntry() = entry
    )
  }

  private Instruction getFirstRangeVariableDeclStmtInstruction(EdgeKind kind) {
    result = this.getRangeVariableDeclStmt().getFirstInstruction(kind)
  }

  private TranslatedDeclStmt getBeginEndVariableDeclStmt() {
    exists(IRVariableDeclarationEntry entry |
      entry.getStmt() = stmt.getBeginEndDeclaration() and
      result.getAnIRDeclarationEntry() = entry
    )
  }

  // Public for getInstructionBackEdgeSuccessor
  final TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  // Public for getInstructionBackEdgeSuccessor
  final TranslatedExpr getUpdate() {
    result = getTranslatedExpr(stmt.getUpdate().getFullyConverted())
  }

  private TranslatedDeclStmt getVariableDeclStmt() {
    exists(IRVariableDeclarationEntry entry |
      entry.getDeclaration() = stmt.getVariable() and
      result.getAnIRDeclarationEntry() = entry
    )
  }

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getStmt()) }
}

class TranslatedJumpStmt extends TranslatedStmt {
  override JumpStmt stmt;

  override Instruction getFirstInstruction(EdgeKind kind) {
    // The first instruction is a destructor call, if any.
    result = this.getChildInternal(0).getFirstInstruction(kind)
    or
    // Otherwise, the first (and only) instruction is a `NoOp`
    not exists(this.getChildInternal(0)) and
    result = this.getInstruction(OnlyInstructionTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  private TranslatedCall getTranslatedImplicitDestructorCall(int id) {
    result.getExpr() = stmt.getImplicitDestructorCall(id)
  }

  override TranslatedElement getLastChild() {
    result =
      this.getTranslatedImplicitDestructorCall(max(int id |
          exists(stmt.getImplicitDestructorCall(id))
        ))
  }

  override TranslatedElement getChildInternal(int id) {
    result = this.getTranslatedImplicitDestructorCall(id)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getTranslatedStmt(stmt.getTarget()).getFirstInstruction(kind)
  }

  final override predicate handlesDestructorsExplicitly() { any() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    exists(int id | child = this.getChildInternal(id) |
      // Transition to the next destructor call, if any.
      result = this.getChildInternal(id + 1).getFirstInstruction(kind)
      or
      // And otherwise, exit this element by flowing to the target of the jump.
      not exists(this.getChildInternal(id + 1)) and
      kind instanceof GotoEdge and
      result = this.getInstruction(OnlyInstructionTag())
    )
  }
}

private EdgeKind getCaseEdge(SwitchCase switchCase) {
  exists(CaseEdge edge |
    result = edge and
    hasCaseEdge(switchCase, edge.getMinValue(), edge.getMaxValue())
  )
  or
  switchCase instanceof DefaultCase and result instanceof DefaultEdge
}

class TranslatedSwitchStmt extends TranslatedStmt {
  override SwitchStmt stmt;

  private TranslatedExpr getExpr() {
    result = getTranslatedExpr(stmt.getExpr().getFullyConverted())
  }

  private Instruction getFirstExprInstruction(EdgeKind kind) {
    result = this.getExpr().getFirstInstruction(kind)
  }

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getStmt()) }

  override Instruction getFirstInstruction(EdgeKind kind) {
    if this.hasInitialization()
    then result = this.getInitialization().getFirstInstruction(kind)
    else result = this.getFirstExprInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getBody().getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getBody() }

  override TranslatedElement getChildInternal(int id) {
    id = 0 and result = this.getInitialization()
    or
    id = 1 and result = this.getExpr()
    or
    id = 2 and result = this.getBody()
  }

  private predicate hasInitialization() { exists(stmt.getInitialization()) }

  private TranslatedStmt getInitialization() {
    result = getTranslatedStmt(stmt.getInitialization())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = SwitchBranchTag() and
    opcode instanceof Opcode::Switch and
    resultType = getVoidType()
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SwitchBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = this.getExpr().getResult()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = SwitchBranchTag() and
    exists(SwitchCase switchCase |
      switchCase = stmt.getASwitchCase() and
      kind = getCaseEdge(switchCase) and
      result = getTranslatedStmt(switchCase).getFirstInstruction(any(GotoEdge edge))
    )
    or
    not stmt.hasDefaultCase() and
    tag = SwitchBranchTag() and
    kind instanceof DefaultEdge and
    result = this.getParent().getChildSuccessor(this, any(GotoEdge edge))
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitialization() and
    result = this.getFirstExprInstruction(kind)
    or
    kind instanceof GotoEdge and
    child = this.getExpr() and
    result = this.getInstruction(SwitchBranchTag())
    or
    child = this.getBody() and result = this.getParent().getChildSuccessor(this, kind)
  }
}

class TranslatedAsmStmt extends TranslatedStmt {
  override AsmStmt stmt;

  override TranslatedExpr getChildInternal(int id) {
    result = getTranslatedExpr(stmt.getChild(id).(Expr).getFullyConverted())
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    if exists(this.getChild(0))
    then result = this.getChild(0).getFirstInstruction(kind)
    else (
      kind instanceof GotoEdge and result = this.getInstruction(AsmTag())
    )
  }

  override Instruction getALastInstructionInternal() { result = this.getInstruction(AsmTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = AsmTag() and
    opcode instanceof Opcode::InlineAsm and
    resultType = getUnknownType()
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    exists(int index |
      tag = AsmTag() and
      operandTag = asmOperand(index) and
      result = this.getChildInternal(index).getResult()
    )
  }

  final override CppType getInstructionMemoryOperandType(
    InstructionTag tag, TypedOperandTag operandTag
  ) {
    tag = AsmTag() and
    operandTag instanceof SideEffectOperandTag and
    result = getUnknownType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = AsmTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    exists(int index |
      child = this.getChild(index) and
      if exists(this.getChild(index + 1))
      then result = this.getChild(index + 1).getFirstInstruction(kind)
      else (
        kind instanceof GotoEdge and result = this.getInstruction(AsmTag())
      )
    )
  }
}

class TranslatedVlaDimensionStmt extends TranslatedStmt {
  override VlaDimensionStmt stmt;

  override TranslatedExpr getChildInternal(int id) {
    id = 0 and
    result = getTranslatedExpr(stmt.getDimensionExpr().getFullyConverted())
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getChild(0).getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getChild(0).getALastInstruction()
  }

  override TranslatedElement getLastChild() { result = this.getChild(0) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getChild(0) and
    result = this.getParent().getChildSuccessor(this, kind)
  }
}

class TranslatedVlaDeclarationStmt extends TranslatedStmt {
  override VlaDeclStmt stmt;

  override TranslatedExpr getChildInternal(int id) { none() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(OnlyInstructionTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    // TODO: This needs a new kind of instruction that represents initialization of a VLA.
    // For now we just emit a `NoOp` instruction so that the CFG isn't incomplete.
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) { none() }
}

class TranslatedCoReturnStmt extends TranslatedStmt {
  override CoReturnStmt stmt;

  private TranslatedExpr getTranslatedOperand() {
    result = getTranslatedExpr(stmt.getOperand().getFullyConverted())
  }

  override TranslatedExpr getChildInternal(int id) {
    id = 0 and
    result = this.getTranslatedOperand()
  }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getTranslatedOperand().getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getTranslatedOperand() and
    kind instanceof GotoEdge and
    result = this.getInstruction(OnlyInstructionTag())
  }
}
