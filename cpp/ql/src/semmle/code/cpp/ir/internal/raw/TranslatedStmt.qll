import cpp
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
  DeclStmt declStmt;

  TranslatedDeclStmt() {
    declStmt = stmt
  }

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
    result = declStmt.getNumDeclarations()
  }

  private TranslatedDeclarationEntry getDeclarationEntry(int index) {
    result = getTranslatedDeclarationEntry(declStmt.getDeclarationEntry(index))
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
  TranslatedExprStmt() {
    stmt instanceof ExprStmt
  }

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
  ReturnStmt returnStmt;

  TranslatedReturnStmt() {
    returnStmt = stmt
  }

  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(returnStmt.getEnclosingFunction())
  }
}

class TranslatedReturnValueStmt extends TranslatedReturnStmt,
  InitializationContext {
  TranslatedReturnValueStmt() {
    returnStmt.hasExpr()
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
      returnStmt.getExpr().getFullyConverted())
  }
}

class TranslatedReturnVoidStmt extends TranslatedReturnStmt {
  TranslatedReturnVoidStmt() {
    not returnStmt.hasExpr()
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
  TryStmt try;

  TranslatedTryStmt() {
    try = stmt
  }

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
      handler = getHandler(try.getNumberOfCatchClauses()) and
      result = getParent().getExceptionSuccessorInstruction()
    )
  }

  override final Instruction getExceptionSuccessorInstruction() {
    result = getHandler(0).getFirstInstruction()
  }

  private TranslatedHandler getHandler(int index) {
    result = getTranslatedStmt(try.getChild(index + 1))
  }

  private TranslatedStmt getBody() {
    result = getTranslatedStmt(try.getStmt())
  }
}

class TranslatedBlock extends TranslatedStmt {
  Block block;

  TranslatedBlock() {
    block = stmt
  }

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
    not exists(block.getStmt(0))
  }

  private TranslatedStmt getStmt(int index) {
    result = getTranslatedStmt(block.getStmt(index))
  }

  private int getStmtCount() {
    result = block.getNumStmt()
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
  Handler handler;

  TranslatedHandler() {
    handler = stmt
  }

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
    result = getTranslatedStmt(handler.getBlock())
  }
}

/**
 * The IR translation of a C++ `catch` block that catches an exception with a
 * specific type (e.g. `catch (const std::exception&)`).
 */
class TranslatedCatchByTypeHandler extends TranslatedHandler {
  TranslatedCatchByTypeHandler() {
    exists(handler.getParameter())
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
    result = handler.getParameter().getType()
  }

  private TranslatedParameter getParameter() {
    result = getTranslatedParameter(handler.getParameter())
  }
}

/**
 * The IR translation of a C++ `catch (...)` block.
 */
class TranslatedCatchAnyHandler extends TranslatedHandler {
  TranslatedCatchAnyHandler() {
    not exists(handler.getParameter())
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
  IfStmt ifStmt;

  TranslatedIfStmt() {
    stmt = ifStmt
  }

  override Instruction getFirstInstruction() {
    result = getCondition().getFirstInstruction()
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getCondition() or
    id = 1 and result = getThen() or
    id = 2 and result = getElse()
  }

  private TranslatedCondition getCondition() {
    result = getTranslatedCondition(ifStmt.getCondition().getFullyConverted())
  }

  private TranslatedStmt getThen() {
    result = getTranslatedStmt(ifStmt.getThen())
  }

  private TranslatedStmt getElse() {
    result = getTranslatedStmt(ifStmt.getElse())
  }

  private predicate hasElse() {
    exists(ifStmt.getElse())
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
  Loop loop;

  TranslatedLoop() {
    loop = stmt
  }

  final TranslatedCondition getCondition() {
    result = getTranslatedCondition(loop.getCondition().getFullyConverted())
  }

  final TranslatedStmt getBody() {
    result = getTranslatedStmt(loop.getStmt())
  }

  final Instruction getFirstConditionInstruction() {
    if hasCondition() then
      result = getCondition().getFirstInstruction()
    else
      result = getBody().getFirstInstruction()
  }

  final predicate hasCondition() {
    exists(loop.getCondition())
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
  ForStmt forStmt;

  TranslatedForStmt() {
    forStmt = stmt
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization() or
    id = 1 and result = getCondition() or
    id = 2 and result = getUpdate() or
    id = 3 and result = getBody()
  }

  private TranslatedStmt getInitialization() {
    result = getTranslatedStmt(forStmt.getInitialization())
  }

  private predicate hasInitialization() {
    exists(forStmt.getInitialization())
  }
  
  private TranslatedExpr getUpdate() {
    result = getTranslatedExpr(forStmt.getUpdate().getFullyConverted())
  }

  private predicate hasUpdate() {
    exists(forStmt.getUpdate())
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

class TranslatedJumpStmt extends TranslatedStmt {
  JumpStmt jump;

  TranslatedJumpStmt() {
    stmt = jump
  }

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
    result = getTranslatedStmt(jump.getTarget()).getFirstInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
}

class TranslatedSwitchStmt extends TranslatedStmt {
  SwitchStmt switchStmt;

  TranslatedSwitchStmt() {
    switchStmt = stmt
  }

  private TranslatedExpr getExpr() {
    result = getTranslatedExpr(switchStmt.getExpr().getFullyConverted())
  }

  private TranslatedStmt getBody() {
    result = getTranslatedStmt(switchStmt.getStmt())
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
    operandTag instanceof ConditionOperand and
    result = getExpr().getResult()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = SwitchBranchTag() and
    exists(SwitchCase switchCase |
      switchCase = switchStmt.getASwitchCase() and
      kind = getCaseEdge(switchCase) and
      result = getTranslatedStmt(switchCase).getFirstInstruction()
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getExpr() and result = getInstruction(SwitchBranchTag()) or
    child = getBody() and result = getParent().getChildSuccessor(this)
  }
}
