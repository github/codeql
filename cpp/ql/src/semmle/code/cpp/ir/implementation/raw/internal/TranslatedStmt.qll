private import cpp
private import semmle.code.cpp.ir.internal.IRUtilities
private import semmle.code.cpp.ir.internal.OperandTag
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedDeclarationEntry
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction
private import TranslatedInitialization

TranslatedStmt getTranslatedStmt(Stmt stmt) {
  result.getAST() = stmt
}

abstract class TranslatedStmt extends TranslatedElement, TTranslatedStmt {
  Stmt stmt;

  TranslatedStmt() {
    this = TTranslatedStmt(stmt)
  }

  override final string toString() {
    result = stmt.toString()
  }

  override final Locatable getAST() {
    result = stmt
  }

  override final Function getFunction() {
    result = stmt.getEnclosingFunction()
  }
}

class TranslatedEmptyStmt extends TranslatedStmt {
  TranslatedEmptyStmt() {
    stmt instanceof EmptyStmt or
    stmt instanceof LabelStmt or
    stmt instanceof SwitchCase
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType instanceof VoidType and
    isGLValue = false
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

class TranslatedDeclStmt extends TranslatedStmt {
  override DeclStmt stmt;

  override TranslatedElement getChild(int id) {
    result = getDeclarationEntry(id)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getDeclarationEntry(0).getFirstInstruction() //REVIEW: Empty?
  }

  private int getChildCount() {
    result = stmt.getNumDeclarations()
  }

  private TranslatedDeclarationEntry getDeclarationEntry(int index) {
    result = getTranslatedDeclarationEntry(stmt.getDeclarationEntry(index))
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = getDeclarationEntry(index) and
      if index = (getChildCount() - 1) then
        result = getParent().getChildSuccessor(this)
      else
        result = getDeclarationEntry(index + 1).getFirstInstruction()
    )
  }
}

class TranslatedExprStmt extends TranslatedStmt {
  override ExprStmt stmt;

  TranslatedExpr getExpr() {
    result = getTranslatedExpr(stmt.(ExprStmt).getExpr().getFullyConverted())
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getExpr()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getExpr().getFirstInstruction()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

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

class TranslatedReturnValueStmt extends TranslatedReturnStmt,
  InitializationContext {
  TranslatedReturnValueStmt() {
    stmt.hasExpr()
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
    resultType = getEnclosingFunction().getReturnVariable().getType() and
    isGLValue = true
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = InitializerVariableAddressTag() and
    result = getInitialization().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and
    result = getEnclosingFunction().getReturnSuccessorInstruction()
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getEnclosingFunction().getReturnVariable()
  }

  override Instruction getTargetAddress() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() {
    result = getEnclosingFunction().getReturnVariable().getType()
  }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(
      stmt.getExpr().getFullyConverted())
  }
}

class TranslatedReturnVoidStmt extends TranslatedReturnStmt {
  TranslatedReturnVoidStmt() {
    not stmt.hasExpr()
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType instanceof VoidType and
    isGLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getEnclosingFunction().getReturnSuccessorInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
}

/**
 * The IR translation of a C++ `try` statement.
 */
class TranslatedTryStmt extends TranslatedStmt {
  override TryStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getBody() or
    result = getHandler(id - 1)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    none()   
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()  
  }

  override Instruction getFirstInstruction() {
    result = getBody().getFirstInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    // All children go to the successor of the `try`.
    child = getAChild() and result = getParent().getChildSuccessor(this)
  }

  final Instruction getNextHandler(TranslatedHandler handler) {
    exists(int index |
      handler = getHandler(index) and
      result = getHandler(index + 1).getFirstInstruction()
    ) or
    (
      // The last catch clause flows to the exception successor of the parent
      // of the `try`, because the exception successor of the `try` itself is
      // the first catch clause.
      handler = getHandler(stmt.getNumberOfCatchClauses()) and
      result = getParent().getExceptionSuccessorInstruction()
    )
  }

  override final Instruction getExceptionSuccessorInstruction() {
    result = getHandler(0).getFirstInstruction()
  }

  private TranslatedHandler getHandler(int index) {
    result = getTranslatedStmt(stmt.getChild(index + 1))
  }

  private TranslatedStmt getBody() {
    result = getTranslatedStmt(stmt.getStmt())
  }
}

class TranslatedBlock extends TranslatedStmt {
  override Block stmt;

  override TranslatedElement getChild(int id) {
    result = getStmt(id)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    isEmpty() and
    opcode instanceof Opcode::NoOp and
    tag = OnlyInstructionTag() and
    resultType instanceof VoidType and
    isGLValue = false
  }

  override Instruction getFirstInstruction() {
    if isEmpty() then
      result = getInstruction(OnlyInstructionTag())
    else
      result = getStmt(0).getFirstInstruction()
  }

  private predicate isEmpty() {
    not exists(stmt.getStmt(0))
  }

  private TranslatedStmt getStmt(int index) {
    result = getTranslatedStmt(stmt.getStmt(index))
  }

  private int getStmtCount() {
    result = stmt.getNumStmt()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = getStmt(index) and
      if index = (getStmtCount() - 1) then
        result = getParent().getChildSuccessor(this)
      else
        result = getStmt(index + 1).getFirstInstruction()
    )
  }
}

/**
 * The IR translation of a C++ `catch` handler.
 */
abstract class TranslatedHandler extends TranslatedStmt {
  override Handler stmt;

  override TranslatedElement getChild(int id) {
    id = 1 and result = getBlock()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(CatchTag())
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getBlock() and result = getParent().getChildSuccessor(this)
  }

  override Instruction getExceptionSuccessorInstruction() {
    // A throw from within a `catch` block flows to the handler for the parent of
    // the `try`.
    result = getParent().getParent().getExceptionSuccessorInstruction()
  }

  TranslatedStmt getBlock() {
    result = getTranslatedStmt(stmt.getBlock())
  }
}

/**
 * The IR translation of a C++ `catch` block that catches an exception with a
 * specific type (e.g. `catch (const std::exception&)`).
 */
class TranslatedCatchByTypeHandler extends TranslatedHandler {
  TranslatedCatchByTypeHandler() {
    exists(stmt.getParameter())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = CatchTag() and
    opcode instanceof Opcode::CatchByType and
    resultType instanceof VoidType and
    isGLValue = false
  }

  override TranslatedElement getChild(int id) {
    result = super.getChild(id) or
    id = 0 and result = getParameter()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    result = super.getChildSuccessor(child) or
    child = getParameter() and result = getBlock().getFirstInstruction()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = CatchTag() and
    (
      (
        kind instanceof GotoEdge and
        result = getParameter().getFirstInstruction()
      ) or
      (
        kind instanceof ExceptionEdge and
        result = getParent().(TranslatedTryStmt).getNextHandler(this)
      )
    )
  }

  override Type getInstructionExceptionType(InstructionTag tag) {
    tag = CatchTag() and
    result = stmt.getParameter().getType()
  }

  private TranslatedParameter getParameter() {
    result = getTranslatedParameter(stmt.getParameter())
  }
}

/**
 * The IR translation of a C++ `catch (...)` block.
 */
class TranslatedCatchAnyHandler extends TranslatedHandler {
  TranslatedCatchAnyHandler() {
    not exists(stmt.getParameter())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = CatchTag() and
    opcode instanceof Opcode::CatchAny and
    resultType instanceof VoidType and
    isGLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = CatchTag() and
    kind instanceof GotoEdge and
    result = getBlock().getFirstInstruction()
  }
}

class TranslatedIfStmt extends TranslatedStmt, ConditionContext {
  override IfStmt stmt;


  override Instruction getFirstInstruction() {
    result = getCondition().getFirstInstruction()
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getCondition() or
    id = 1 and result = getThen() or
    id = 2 and result = getElse()
  }

  private TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  private TranslatedStmt getThen() {
    result = getTranslatedStmt(stmt.getThen())
  }

  private TranslatedStmt getElse() {
    result = getTranslatedStmt(stmt.getElse())
  }

  private predicate hasElse() {
    exists(stmt.getElse())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = getCondition() and
    result = getThen().getFirstInstruction()
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = getCondition() and
    if hasElse() then
      result = getElse().getFirstInstruction()
    else
      result = getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (child = getThen() or child = getElse()) and
    result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    none()
  }
}

abstract class TranslatedLoop extends TranslatedStmt, ConditionContext {
  override Loop stmt;

  final TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition().getFullyConverted())
  }

  final TranslatedStmt getBody() {
    result = getTranslatedStmt(stmt.getStmt())
  }

  final Instruction getFirstConditionInstruction() {
    if hasCondition() then
      result = getCondition().getFirstInstruction()
    else
      result = getBody().getFirstInstruction()
  }

  final predicate hasCondition() {
    exists(stmt.getCondition())
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getCondition() or
    id = 1 and result = getBody()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    none()
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

  override final Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = getCondition() and result = getBody().getFirstInstruction()
  }

  override final Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = getCondition() and result = getParent().getChildSuccessor(this)
  }
}

class TranslatedWhileStmt extends TranslatedLoop {
  TranslatedWhileStmt() {
    stmt instanceof WhileStmt
  }

  override Instruction getFirstInstruction() {
    result = getFirstConditionInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getBody() and result = getFirstConditionInstruction()
  }
}

class TranslatedDoStmt extends TranslatedLoop {
  TranslatedDoStmt() {
    stmt instanceof DoStmt
  }

  override Instruction getFirstInstruction() {
    result = getBody().getFirstInstruction()
  }
  
  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getBody() and result = getFirstConditionInstruction()
  }
}

class TranslatedForStmt extends TranslatedLoop {
  override ForStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization() or
    id = 1 and result = getCondition() or
    id = 2 and result = getUpdate() or
    id = 3 and result = getBody()
  }

  private TranslatedStmt getInitialization() {
    result = getTranslatedStmt(stmt.getInitialization())
  }

  private predicate hasInitialization() {
    exists(stmt.getInitialization())
  }
  
  TranslatedExpr getUpdate() {
    result = getTranslatedExpr(stmt.getUpdate().getFullyConverted())
  }

  private predicate hasUpdate() {
    exists(stmt.getUpdate())
  }

  override Instruction getFirstInstruction() {
    if hasInitialization() then
      result = getInitialization().getFirstInstruction()
    else
      result = getFirstConditionInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = getInitialization() and
      result = getFirstConditionInstruction()
    ) or
    (
      child = getBody() and
      if hasUpdate() then
        result = getUpdate().getFirstInstruction()
      else
        result = getFirstConditionInstruction()
    ) or
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
    id = 0 and result = getRangeVariableDeclaration() or
    id = 1 and result = getBeginVariableDeclaration() or
    id = 2 and result = getEndVariableDeclaration() or
    id = 3 and result = getCondition() or
    id = 4 and result = getUpdate() or
    id = 5 and result = getVariableDeclaration() or
    id = 6 and result = getBody()
  }

  override Instruction getFirstInstruction() {
    result = getRangeVariableDeclaration().getFirstInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = getRangeVariableDeclaration() and
      result = getBeginVariableDeclaration().getFirstInstruction()
    ) or
    (
      child = getBeginVariableDeclaration() and
      result = getEndVariableDeclaration().getFirstInstruction()
    ) or
    (
      child = getEndVariableDeclaration() and
      result = getCondition().getFirstInstruction()
    ) or
    (
      child = getVariableDeclaration() and
      result = getBody().getFirstInstruction()
    ) or
    (
      child = getBody() and
      result = getUpdate().getFirstInstruction()
    ) or
    (
      child = getUpdate() and
      result = getCondition().getFirstInstruction()
    )
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType,
      boolean isGLValue) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    none()
  }

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

  private TranslatedStmt getBody() {
    result = getTranslatedStmt(stmt.getStmt())
  }
}

class TranslatedJumpStmt extends TranslatedStmt {
  override JumpStmt stmt;

  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType instanceof VoidType and
    isGLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getTranslatedStmt(stmt.getTarget()).getFirstInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
}

private EdgeKind getCaseEdge(SwitchCase switchCase) {
  exists(CaseEdge edge |
    result = edge and
    hasCaseEdge(switchCase, edge.getMinValue(), edge.getMaxValue())
  ) or
  (switchCase instanceof DefaultCase and result instanceof DefaultEdge)
}

class TranslatedSwitchStmt extends TranslatedStmt {
  override SwitchStmt stmt;

  private TranslatedExpr getExpr() {
    result = getTranslatedExpr(stmt.getExpr().getFullyConverted())
  }

  private TranslatedStmt getBody() {
    result = getTranslatedStmt(stmt.getStmt())
  }

  override Instruction getFirstInstruction() {
    result = getExpr().getFirstInstruction()
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getExpr() or
    id = 1 and result = getBody()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = SwitchBranchTag() and
    opcode instanceof Opcode::Switch and
    resultType instanceof VoidType and
    isGLValue = false
  }

  override Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = SwitchBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = getExpr().getResult()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = SwitchBranchTag() and
    exists(SwitchCase switchCase |
      switchCase = stmt.getASwitchCase() and
      kind = getCaseEdge(switchCase) and
      result = getTranslatedStmt(switchCase).getFirstInstruction()
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getExpr() and result = getInstruction(SwitchBranchTag()) or
    child = getBody() and result = getParent().getChildSuccessor(this)
  }
}

class TranslatedAsmStmt extends TranslatedStmt {
  override AsmStmt stmt;

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    if exists(stmt.getChild(0))
    then result = getInstruction(AsmInputTag(0))
    else result = getInstruction(AsmTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    tag = AsmTag() and
    opcode instanceof Opcode::InlineAsm and
    resultType instanceof UnknownType and
    isGLValue = false
    or
    exists(int index, VariableAccess va |
      tag = AsmInputTag(index) and
      stmt.getChild(index) = va and
      opcode instanceof Opcode::VariableAddress and
      resultType = va.getType().getUnspecifiedType() and
      isGLValue = true
    )
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    exists(int index |
      tag = AsmInputTag(index) and
      result = getIRUserVariable(stmt.getEnclosingFunction(), stmt.getChild(index).(VariableAccess).getTarget())
    )
  }
  
  override Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = AsmTag() and
    operandTag instanceof SideEffectOperandTag and
    result = getTranslatedFunction(stmt.getEnclosingFunction()).getUnmodeledDefinitionInstruction()
    or
    exists(int index |
      tag = AsmTag() and
      operandTag = asmOperand(index) and
      result = getInstruction(AsmInputTag(index))
    )
  }

  override final Type getInstructionOperandType(InstructionTag tag,
      TypedOperandTag operandTag) {
    tag = AsmTag() and
    operandTag instanceof SideEffectOperandTag and
    result instanceof UnknownType
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    tag = AsmTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
    or
    exists(int index |
      tag = AsmInputTag(index) and
      kind instanceof GotoEdge and
      if exists(stmt.getChild(index + 1))
      then 
        result = getInstruction(AsmInputTag(index + 1))
      else
        result = getInstruction(AsmTag())
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
}
