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

abstract class TranslatedStmt extends TranslatedElement, TTranslatedStmt {
  Stmt stmt;

  TranslatedStmt() { this = TTranslatedStmt(stmt) }

  final override string toString() { result = stmt.toString() }

  final override Locatable getAst() { result = stmt }

  /** DEPRECATED: Alias for getAst */
  deprecated override Locatable getAST() { result = getAst() }

  final override Function getFunction() { result = stmt.getEnclosingFunction() }
}

class TranslatedEmptyStmt extends TranslatedStmt {
  TranslatedEmptyStmt() {
    stmt instanceof EmptyStmt or
    stmt instanceof LabelStmt or
    stmt instanceof SwitchCase
  }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

/**
 * The IR translation of a declaration statement. This consists of the IR for each of the individual
 * local variables declared by the statement. Declarations for extern variables and functions
 * do not generate any instructions.
 */
class TranslatedDeclStmt extends TranslatedStmt {
  override DeclStmt stmt;

  override TranslatedElement getChild(int id) { result = getDeclarationEntry(id) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getDeclarationEntry(0).getFirstInstruction()
    or
    not exists(getDeclarationEntry(0)) and result = getParent().getChildSuccessor(this)
  }

  private int getChildCount() { result = count(getDeclarationEntry(_)) }

  /**
   * Gets the `TranslatedDeclarationEntry` child at zero-based index `index`. Since not all
   * `DeclarationEntry` objects have a `TranslatedDeclarationEntry` (e.g. extern functions), we map
   * the original children into a contiguous range containing only those with an actual
   * `TranslatedDeclarationEntry`.
   */
  private TranslatedDeclarationEntry getDeclarationEntry(int index) {
    result =
      rank[index + 1](TranslatedDeclarationEntry entry, int originalIndex |
        entry = getTranslatedDeclarationEntry(stmt.getDeclarationEntry(originalIndex))
      |
        entry order by originalIndex
      )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = getDeclarationEntry(index) and
      if index = (getChildCount() - 1)
      then result = getParent().getChildSuccessor(this)
      else result = getDeclarationEntry(index + 1).getFirstInstruction()
    )
  }
}

class TranslatedExprStmt extends TranslatedStmt {
  override ExprStmt stmt;

  TranslatedExpr getExpr() { result = getTranslatedExpr(stmt.getExpr().getFullyConverted()) }

  override TranslatedElement getChild(int id) { id = 0 and result = getExpr() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getFirstInstruction() { result = getExpr().getFirstInstruction() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getExpr() and
    result = getParent().getChildSuccessor(this)
  }
}

abstract class TranslatedReturnStmt extends TranslatedStmt {
  override ReturnStmt stmt;

  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(stmt.getEnclosingFunction())
  }
}

/**
 * The IR translation of a `return` statement that returns a value.
 */
class TranslatedReturnValueStmt extends TranslatedReturnStmt, TranslatedVariableInitialization {
  TranslatedReturnValueStmt() { stmt.hasExpr() and hasReturnValue(stmt.getEnclosingFunction()) }

  final override Instruction getInitializationSuccessor() {
    result = getEnclosingFunction().getReturnSuccessorInstruction()
  }

  final override Type getTargetType() { result = getEnclosingFunction().getReturnType() }

  final override TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(stmt.getExpr().getFullyConverted())
  }

  final override IRVariable getIRVariable() { result = getEnclosingFunction().getReturnVariable() }
}

/**
 * The IR translation of a `return` statement that returns an expression of `void` type.
 */
class TranslatedReturnVoidExpressionStmt extends TranslatedReturnStmt {
  TranslatedReturnVoidExpressionStmt() {
    stmt.hasExpr() and not hasReturnValue(stmt.getEnclosingFunction())
  }

  override TranslatedElement getChild(int id) {
    id = 0 and
    result = getExpr()
  }

  override Instruction getFirstInstruction() { result = getExpr().getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getEnclosingFunction().getReturnSuccessorInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getExpr() and
    result = getInstruction(OnlyInstructionTag())
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

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getEnclosingFunction().getReturnSuccessorInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

/**
 * The IR translation of an implicit `return` statement generated by the extractor to handle control
 * flow that reaches the end of a non-`void`-returning function body. Since such control flow
 * produces undefined behavior, we simply generate an `Unreached` instruction to prevent that flow
 * from continuing on to pollute other analysis. The assumption is that the developer is certain
 * that the implicit `return` is unreachable, even if the compiler cannot prove it.
 */
class TranslatedUnreachableReturnStmt extends TranslatedReturnStmt {
  TranslatedUnreachableReturnStmt() {
    not stmt.hasExpr() and hasReturnValue(stmt.getEnclosingFunction())
  }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::Unreached and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

/**
 * The IR translation of a C++ `try` statement.
 */
class TranslatedTryStmt extends TranslatedStmt {
  override TryStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getBody()
    or
    result = getHandler(id - 1)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getFirstInstruction() { result = getBody().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    // All children go to the successor of the `try`.
    child = getAChild() and result = getParent().getChildSuccessor(this)
  }

  final Instruction getNextHandler(TranslatedHandler handler) {
    exists(int index |
      handler = getHandler(index) and
      result = getHandler(index + 1).getFirstInstruction()
    )
    or
    // The last catch clause flows to the exception successor of the parent
    // of the `try`, because the exception successor of the `try` itself is
    // the first catch clause.
    handler = getHandler(stmt.getNumberOfCatchClauses() - 1) and
    result = getParent().getExceptionSuccessorInstruction()
  }

  final override Instruction getExceptionSuccessorInstruction() {
    result = getHandler(0).getFirstInstruction()
  }

  private TranslatedHandler getHandler(int index) {
    result = getTranslatedStmt(stmt.getChild(index + 1))
  }

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getStmt()) }
}

class TranslatedBlock extends TranslatedStmt {
  override BlockStmt stmt;

  override TranslatedElement getChild(int id) { result = getStmt(id) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    isEmpty() and
    opcode instanceof Opcode::NoOp and
    tag = OnlyInstructionTag() and
    resultType = getVoidType()
  }

  override Instruction getFirstInstruction() {
    if isEmpty()
    then result = getInstruction(OnlyInstructionTag())
    else result = getStmt(0).getFirstInstruction()
  }

  private predicate isEmpty() { not exists(stmt.getStmt(0)) }

  private TranslatedStmt getStmt(int index) { result = getTranslatedStmt(stmt.getStmt(index)) }

  private int getStmtCount() { result = stmt.getNumStmt() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = getStmt(index) and
      if index = (getStmtCount() - 1)
      then result = getParent().getChildSuccessor(this)
      else result = getStmt(index + 1).getFirstInstruction()
    )
  }
}

/**
 * The IR translation of a C++ `catch` handler.
 */
abstract class TranslatedHandler extends TranslatedStmt {
  override Handler stmt;

  override TranslatedElement getChild(int id) { id = 1 and result = getBlock() }

  override Instruction getFirstInstruction() { result = getInstruction(CatchTag()) }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getBlock() and result = getParent().getChildSuccessor(this)
  }

  override Instruction getExceptionSuccessorInstruction() {
    // A throw from within a `catch` block flows to the handler for the parent of
    // the `try`.
    result = getParent().getParent().getExceptionSuccessorInstruction()
  }

  TranslatedStmt getBlock() { result = getTranslatedStmt(stmt.getBlock()) }
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

  override TranslatedElement getChild(int id) {
    result = super.getChild(id)
    or
    id = 0 and result = getParameter()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    result = super.getChildSuccessor(child)
    or
    child = getParameter() and result = getBlock().getFirstInstruction()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = CatchTag() and
    (
      kind instanceof GotoEdge and
      result = getParameter().getFirstInstruction()
      or
      kind instanceof ExceptionEdge and
      result = getParent().(TranslatedTryStmt).getNextHandler(this)
    )
  }

  override CppType getInstructionExceptionType(InstructionTag tag) {
    tag = CatchTag() and
    result = getTypeForPRValue(stmt.getParameter().getType())
  }

  private TranslatedParameter getParameter() {
    result = getTranslatedParameter(stmt.getParameter())
  }
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

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = CatchTag() and
    kind instanceof GotoEdge and
    result = getBlock().getFirstInstruction()
  }
}

class TranslatedIfStmt extends TranslatedStmt, ConditionContext {
  override IfStmt stmt;

  override Instruction getFirstInstruction() { result = getCondition().getFirstInstruction() }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getCondition()
    or
    id = 1 and result = getThen()
    or
    id = 2 and result = getElse()
  }

  private TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  private TranslatedStmt getThen() { result = getTranslatedStmt(stmt.getThen()) }

  private TranslatedStmt getElse() { result = getTranslatedStmt(stmt.getElse()) }

  private predicate hasElse() { exists(stmt.getElse()) }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = getCondition() and
    result = getThen().getFirstInstruction()
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = getCondition() and
    if hasElse()
    then result = getElse().getFirstInstruction()
    else result = getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (child = getThen() or child = getElse()) and
    result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }
}

abstract class TranslatedLoop extends TranslatedStmt, ConditionContext {
  override Loop stmt;

  final TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  final TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getStmt()) }

  final Instruction getFirstConditionInstruction() {
    if hasCondition()
    then result = getCondition().getFirstInstruction()
    else result = getBody().getFirstInstruction()
  }

  final predicate hasCondition() { exists(stmt.getCondition()) }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getCondition()
    or
    id = 1 and result = getBody()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = getCondition() and result = getBody().getFirstInstruction()
  }

  final override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = getCondition() and result = getParent().getChildSuccessor(this)
  }
}

class TranslatedWhileStmt extends TranslatedLoop {
  TranslatedWhileStmt() { stmt instanceof WhileStmt }

  override Instruction getFirstInstruction() { result = getFirstConditionInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getBody() and result = getFirstConditionInstruction()
  }
}

class TranslatedDoStmt extends TranslatedLoop {
  TranslatedDoStmt() { stmt instanceof DoStmt }

  override Instruction getFirstInstruction() { result = getBody().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getBody() and result = getFirstConditionInstruction()
  }
}

class TranslatedForStmt extends TranslatedLoop {
  override ForStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
    or
    id = 1 and result = getCondition()
    or
    id = 2 and result = getUpdate()
    or
    id = 3 and result = getBody()
  }

  private TranslatedStmt getInitialization() {
    result = getTranslatedStmt(stmt.getInitialization())
  }

  private predicate hasInitialization() { exists(stmt.getInitialization()) }

  TranslatedExpr getUpdate() { result = getTranslatedExpr(stmt.getUpdate().getFullyConverted()) }

  private predicate hasUpdate() { exists(stmt.getUpdate()) }

  override Instruction getFirstInstruction() {
    if hasInitialization()
    then result = getInitialization().getFirstInstruction()
    else result = getFirstConditionInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and
    result = getFirstConditionInstruction()
    or
    (
      child = getBody() and
      if hasUpdate()
      then result = getUpdate().getFirstInstruction()
      else result = getFirstConditionInstruction()
    )
    or
    child = getUpdate() and result = getFirstConditionInstruction()
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

  override TranslatedElement getChild(int id) {
    id = 0 and result = getRangeVariableDeclaration()
    or
    id = 1 and result = getBeginVariableDeclaration()
    or
    id = 2 and result = getEndVariableDeclaration()
    or
    id = 3 and result = getCondition()
    or
    id = 4 and result = getUpdate()
    or
    id = 5 and result = getVariableDeclaration()
    or
    id = 6 and result = getBody()
  }

  override Instruction getFirstInstruction() {
    result = getRangeVariableDeclaration().getFirstInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getRangeVariableDeclaration() and
    result = getBeginVariableDeclaration().getFirstInstruction()
    or
    child = getBeginVariableDeclaration() and
    result = getEndVariableDeclaration().getFirstInstruction()
    or
    child = getEndVariableDeclaration() and
    result = getCondition().getFirstInstruction()
    or
    child = getVariableDeclaration() and
    result = getBody().getFirstInstruction()
    or
    child = getBody() and
    result = getUpdate().getFirstInstruction()
    or
    child = getUpdate() and
    result = getCondition().getFirstInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = getCondition() and result = getVariableDeclaration().getFirstInstruction()
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = getCondition() and result = getParent().getChildSuccessor(this)
  }

  private TranslatedRangeBasedForVariableDeclaration getRangeVariableDeclaration() {
    result = getTranslatedRangeBasedForVariableDeclaration(stmt.getRangeVariable())
  }

  private TranslatedRangeBasedForVariableDeclaration getBeginVariableDeclaration() {
    result = getTranslatedRangeBasedForVariableDeclaration(stmt.getBeginVariable())
  }

  private TranslatedRangeBasedForVariableDeclaration getEndVariableDeclaration() {
    result = getTranslatedRangeBasedForVariableDeclaration(stmt.getEndVariable())
  }

  // Public for getInstructionBackEdgeSuccessor
  final TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  // Public for getInstructionBackEdgeSuccessor
  final TranslatedExpr getUpdate() {
    result = getTranslatedExpr(stmt.getUpdate().getFullyConverted())
  }

  private TranslatedRangeBasedForVariableDeclaration getVariableDeclaration() {
    result = getTranslatedRangeBasedForVariableDeclaration(stmt.getVariable())
  }

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getStmt()) }
}

class TranslatedJumpStmt extends TranslatedStmt {
  override JumpStmt stmt;

  override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  override TranslatedElement getChild(int id) { none() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getTranslatedStmt(stmt.getTarget()).getFirstInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
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

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getStmt()) }

  override Instruction getFirstInstruction() { result = getExpr().getFirstInstruction() }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getExpr()
    or
    id = 1 and result = getBody()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = SwitchBranchTag() and
    opcode instanceof Opcode::Switch and
    resultType = getVoidType()
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SwitchBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = getExpr().getResult()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = SwitchBranchTag() and
    exists(SwitchCase switchCase |
      switchCase = stmt.getASwitchCase() and
      kind = getCaseEdge(switchCase) and
      result = getTranslatedStmt(switchCase).getFirstInstruction()
    )
    or
    not stmt.hasDefaultCase() and
    tag = SwitchBranchTag() and
    kind instanceof DefaultEdge and
    result = getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getExpr() and result = getInstruction(SwitchBranchTag())
    or
    child = getBody() and result = getParent().getChildSuccessor(this)
  }
}

class TranslatedAsmStmt extends TranslatedStmt {
  override AsmStmt stmt;

  override TranslatedExpr getChild(int id) {
    result = getTranslatedExpr(stmt.getChild(id).(Expr).getFullyConverted())
  }

  override Instruction getFirstInstruction() {
    if exists(getChild(0))
    then result = getChild(0).getFirstInstruction()
    else result = getInstruction(AsmTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = AsmTag() and
    opcode instanceof Opcode::InlineAsm and
    resultType = getUnknownType()
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    exists(int index |
      tag = AsmTag() and
      operandTag = asmOperand(index) and
      result = getChild(index).getResult()
    )
  }

  final override CppType getInstructionMemoryOperandType(
    InstructionTag tag, TypedOperandTag operandTag
  ) {
    tag = AsmTag() and
    operandTag instanceof SideEffectOperandTag and
    result = getUnknownType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = AsmTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = getChild(index) and
      if exists(getChild(index + 1))
      then result = getChild(index + 1).getFirstInstruction()
      else result = getInstruction(AsmTag())
    )
  }
}
