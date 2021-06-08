import csharp
private import experimental.ir.internal.CSharpType
private import experimental.ir.internal.TempVariableTag
private import experimental.ir.implementation.internal.OperandTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedDeclaration
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction
private import TranslatedInitialization
private import common.TranslatedConditionBase
private import IRInternal
private import experimental.ir.internal.IRUtilities
private import desugar.Foreach
private import desugar.Lock

TranslatedStmt getTranslatedStmt(Stmt stmt) { result.getAST() = stmt }

abstract class TranslatedStmt extends TranslatedElement, TTranslatedStmt {
  Stmt stmt;

  TranslatedStmt() { this = TTranslatedStmt(stmt) }

  final override string toString() { result = stmt.toString() }

  final override Language::AST getAST() { result = stmt }

  final override Callable getFunction() { result = stmt.getEnclosingCallable() }
}

class TranslatedEmptyStmt extends TranslatedStmt {
  TranslatedEmptyStmt() {
    stmt instanceof EmptyStmt or
    stmt instanceof LabelStmt or
    stmt instanceof CaseStmt
  }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = this.getInstruction(OnlyInstructionTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

class TranslatedDeclStmt extends TranslatedStmt {
  override LocalVariableDeclStmt stmt;

  override TranslatedElement getChild(int id) { result = this.getLocalDeclaration(id) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = this.getLocalDeclaration(0).getFirstInstruction()
  }

  private int getChildCount() { result = count(stmt.getAVariableDeclExpr()) }

  private TranslatedLocalDeclaration getLocalDeclaration(int index) {
    result = getTranslatedLocalDeclaration(stmt.getVariableDeclExpr(index))
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = this.getLocalDeclaration(index) and
      if index = (getChildCount() - 1)
      then result = this.getParent().getChildSuccessor(this)
      else result = this.getLocalDeclaration(index + 1).getFirstInstruction()
    )
  }
}

class TranslatedExprStmt extends TranslatedStmt {
  override ExprStmt stmt;

  TranslatedExpr getExpr() { result = getTranslatedExpr(stmt.(ExprStmt).getExpr()) }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getExpr() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getFirstInstruction() { result = this.getExpr().getFirstInstruction() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getExpr() and
    result = this.getParent().getChildSuccessor(this)
  }
}

/**
 * Class that deals with an `ExprStmt` whose child is an `AssignExpr` whose
 * lvalue is an accessor call.
 * Since we desugar such an expression to function call,
 * we ignore the assignment and make the only child of the translated statement
 * the accessor call.
 */
class TranslatedExprStmtAccessorSet extends TranslatedExprStmt {
  override ExprStmt stmt;

  TranslatedExprStmtAccessorSet() {
    stmt.getExpr() instanceof AssignExpr and
    stmt.getExpr().(AssignExpr).getLValue() instanceof AccessorCall
  }

  override TranslatedExpr getExpr() {
    result = getTranslatedExpr(stmt.(ExprStmt).getExpr().(AssignExpr).getLValue())
  }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getExpr() }

  override Instruction getFirstInstruction() { result = this.getExpr().getFirstInstruction() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getExpr() and
    result = this.getParent().getChildSuccessor(this)
  }
}

abstract class TranslatedReturnStmt extends TranslatedStmt {
  override ReturnStmt stmt;

  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(stmt.getEnclosingCallable())
  }
}

class TranslatedReturnValueStmt extends TranslatedReturnStmt, InitializationContext {
  TranslatedReturnValueStmt() { exists(stmt.getExpr()) }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getInitialization() }

  override Instruction getFirstInstruction() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(this.getEnclosingFunction().getFunction().getReturnType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = InitializerVariableAddressTag() and
    result = this.getInitialization().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getInitialization() and
    result = this.getEnclosingFunction().getReturnSuccessorInstruction()
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = this.getEnclosingFunction().getReturnVariable()
  }

  override Instruction getTargetAddress() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() {
    result = this.getEnclosingFunction().getReturnVariable().getType()
  }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(stmt.getExpr())
  }
}

class TranslatedReturnVoidStmt extends TranslatedReturnStmt {
  TranslatedReturnVoidStmt() { not exists(stmt.getExpr()) }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = this.getInstruction(OnlyInstructionTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getEnclosingFunction().getReturnSuccessorInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

/**
 * The IR translation of a C++ `try` statement.
 */
// TODO: Make sure that if the exception is uncaught or rethrown
//       finally is still executed.
class TranslatedTryStmt extends TranslatedStmt {
  override TryStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = this.getBody()
    or
    id = 1 and result = this.getFinally()
    or
    result = this.getCatchClause(id - 2)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getFirstInstruction() { result = this.getBody().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getCatchClause(_) and result = this.getFinally().getFirstInstruction()
    or
    child = this.getBody() and result = this.getFinally().getFirstInstruction()
    or
    child = this.getFinally() and result = this.getParent().getChildSuccessor(this)
  }

  final Instruction getNextHandler(TranslatedClause clause) {
    exists(int index |
      clause = this.getCatchClause(index) and
      result = this.getCatchClause(index + 1).getFirstInstruction()
    )
    or
    // The last catch clause flows to the exception successor of the parent
    // of the `try`, because the exception successor of the `try` itself is
    // the first catch clause.
    clause = this.getCatchClause(count(stmt.getACatchClause()) - 1) and
    result = this.getParent().getExceptionSuccessorInstruction()
  }

  final override Instruction getExceptionSuccessorInstruction() {
    result = this.getCatchClause(0).getFirstInstruction()
  }

  private TranslatedClause getCatchClause(int index) {
    result = getTranslatedStmt(stmt.getCatchClause(index))
  }

  private TranslatedStmt getFinally() { result = getTranslatedStmt(stmt.getFinally()) }

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getBlock()) }
}

class TranslatedBlock extends TranslatedStmt {
  override BlockStmt stmt;

  override TranslatedElement getChild(int id) { result = this.getStmt(id) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    isEmpty() and
    opcode instanceof Opcode::NoOp and
    tag = OnlyInstructionTag() and
    resultType = getVoidType()
  }

  override Instruction getFirstInstruction() {
    if isEmpty()
    then result = this.getInstruction(OnlyInstructionTag())
    else result = this.getStmt(0).getFirstInstruction()
  }

  private predicate isEmpty() { stmt.isEmpty() }

  private TranslatedStmt getStmt(int index) { result = getTranslatedStmt(stmt.getStmt(index)) }

  private int getStmtCount() { result = count(stmt.getAStmt()) }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = this.getStmt(index) and
      if index = (getStmtCount() - 1)
      then result = this.getParent().getChildSuccessor(this)
      else result = this.getStmt(index + 1).getFirstInstruction()
    )
  }
}

/**
 * The IR translation of a C# `catch` clause.
 */
abstract class TranslatedClause extends TranslatedStmt {
  override CatchClause stmt;

  override TranslatedElement getChild(int id) { id = 1 and result = this.getBlock() }

  override Instruction getFirstInstruction() { result = this.getInstruction(CatchTag()) }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getBlock() and result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getExceptionSuccessorInstruction() {
    // A throw from within a `catch` block flows to the handler for the parent of
    // the `try`.
    result = this.getParent().getParent().getExceptionSuccessorInstruction()
  }

  TranslatedStmt getBlock() { result = getTranslatedStmt(stmt.getBlock()) }
}

/**
 * The IR translation of a C# `catch` block that catches an exception with a
 * specific type (e.g. `catch (Exception ex) { ... }`).
 */
class TranslatedCatchByTypeClause extends TranslatedClause {
  TranslatedCatchByTypeClause() { stmt instanceof SpecificCatchClause }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = CatchTag() and
    opcode instanceof Opcode::CatchByType and
    resultType = getVoidType()
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getParameter()
    or
    result = super.getChild(id)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    result = super.getChildSuccessor(child)
    or
    child = getParameter() and result = this.getBlock().getFirstInstruction()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = CatchTag() and
    (
      kind instanceof GotoEdge and
      result = getParameter().getFirstInstruction()
      or
      kind instanceof ExceptionEdge and
      result = this.getParent().(TranslatedTryStmt).getNextHandler(this)
    )
  }

  override CSharpType getInstructionExceptionType(InstructionTag tag) {
    tag = CatchTag() and
    result = getTypeForPRValue(stmt.(SpecificCatchClause).getVariable().getType())
  }

  private TranslatedLocalDeclaration getParameter() {
    result = getTranslatedLocalDeclaration(stmt.(SpecificCatchClause).getVariableDeclExpr())
  }
}

/**
 * The IR translation of catch block with no parameters.
 */
class TranslatedGeneralCatchClause extends TranslatedClause {
  TranslatedGeneralCatchClause() { stmt instanceof GeneralCatchClause }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = CatchTag() and
    opcode instanceof Opcode::CatchAny and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = CatchTag() and
    kind instanceof GotoEdge and
    result = this.getBlock().getFirstInstruction()
  }
}

/**
 * The IR translation of a throw statement that throws an exception,
 * as oposed to just rethrowing one.
 */
class TranslatedThrowExceptionStmt extends TranslatedStmt, InitializationContext {
  override ThrowStmt stmt;

  TranslatedThrowExceptionStmt() {
    // Must throw an exception
    exists(stmt.getExpr())
  }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getInitialization() }

  override Instruction getFirstInstruction() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = ThrowTag() and
    opcode instanceof Opcode::ThrowValue and
    resultType = getVoidType()
    or
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(this.getExceptionType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = ThrowTag() and
    kind instanceof ExceptionEdge and
    result = this.getParent().getExceptionSuccessorInstruction()
    or
    tag = InitializerVariableAddressTag() and
    result = this.getInitialization().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getInitialization() and
    result = this.getInstruction(ThrowTag())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getIRTempVariable(stmt, ThrowTempVar())
  }

  final override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = ThrowTempVar() and
    type = getTypeForPRValue(this.getExceptionType())
  }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ThrowTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  final override CSharpType getInstructionOperandType(InstructionTag tag, TypedOperandTag operandTag) {
    tag = ThrowTag() and
    operandTag instanceof LoadOperandTag and
    result = getTypeForPRValue(this.getExceptionType())
  }

  override Instruction getTargetAddress() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() { result = this.getExceptionType() }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(stmt.getExpr())
  }

  private Type getExceptionType() { result = stmt.getExpr().getType() }
}

/**
 * The IR translation of a simple throw statement, ie. one that just
 * rethrows an exception.
 */
class TranslatedEmptyThrowStmt extends TranslatedStmt {
  override ThrowStmt stmt;

  TranslatedEmptyThrowStmt() { not exists(stmt.getExpr()) }

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = this.getInstruction(ThrowTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = ThrowTag() and
    opcode instanceof Opcode::ReThrow and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = ThrowTag() and
    kind instanceof ExceptionEdge and
    result = this.getParent().getExceptionSuccessorInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

class TranslatedIfStmt extends TranslatedStmt, ConditionContext {
  override IfStmt stmt;

  override Instruction getFirstInstruction() { result = this.getCondition().getFirstInstruction() }

  override TranslatedElement getChild(int id) {
    id = 0 and result = this.getCondition()
    or
    id = 1 and result = this.getThen()
    or
    id = 2 and result = this.getElse()
  }

  private TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition())
  }

  private TranslatedStmt getThen() { result = getTranslatedStmt(stmt.getThen()) }

  private TranslatedStmt getElse() { result = getTranslatedStmt(stmt.getElse()) }

  private predicate hasElse() { exists(stmt.getElse()) }

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

abstract class TranslatedLoop extends TranslatedStmt, ConditionContext {
  override LoopStmt stmt;

  final TranslatedCondition getCondition() { result = getTranslatedCondition(stmt.getCondition()) }

  final TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getBody()) }

  final Instruction getFirstConditionInstruction() {
    if hasCondition()
    then result = getCondition().getFirstInstruction()
    else result = this.getBody().getFirstInstruction()
  }

  final predicate hasCondition() { exists(stmt.getCondition()) }

  override TranslatedElement getChild(int id) {
    id = 0 and result = this.getCondition()
    or
    id = 1 and result = this.getBody()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final override Instruction getChildTrueSuccessor(ConditionBase child) {
    child = this.getCondition() and result = this.getBody().getFirstInstruction()
  }

  final override Instruction getChildFalseSuccessor(ConditionBase child) {
    child = this.getCondition() and result = this.getParent().getChildSuccessor(this)
  }
}

class TranslatedWhileStmt extends TranslatedLoop {
  TranslatedWhileStmt() { stmt instanceof WhileStmt }

  override Instruction getFirstInstruction() { result = this.getFirstConditionInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getBody() and result = this.getFirstConditionInstruction()
  }
}

class TranslatedDoStmt extends TranslatedLoop {
  TranslatedDoStmt() { stmt instanceof DoStmt }

  override Instruction getFirstInstruction() { result = this.getBody().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getBody() and result = this.getFirstConditionInstruction()
  }
}

class TranslatedForStmt extends TranslatedLoop {
  override ForStmt stmt;

  override TranslatedElement getChild(int id) {
    initializerIndex(id) and result = this.getDeclAndInit(id)
    or
    result = this.getUpdate(updateIndex(id))
    or
    id = initializersNo() + updatesNo() and result = this.getCondition()
    or
    id = initializersNo() + updatesNo() + 1 and result = this.getBody()
  }

  private TranslatedElement getDeclAndInit(int index) {
    if stmt.getInitializer(index) instanceof LocalVariableDeclExpr
    then result = getTranslatedLocalDeclaration(stmt.getInitializer(index))
    else result = getTranslatedExpr(stmt.getInitializer(index))
  }

  private predicate hasInitialization() { exists(stmt.getAnInitializer()) }

  TranslatedExpr getUpdate(int index) { result = getTranslatedExpr(stmt.getUpdate(index)) }

  private predicate hasUpdate() { exists(stmt.getAnUpdate()) }

  private int initializersNo() { result = count(stmt.getAnInitializer()) }

  private int updatesNo() { result = count(stmt.getAnUpdate()) }

  private predicate initializerIndex(int index) { index in [0 .. initializersNo() - 1] }

  private int updateIndex(int index) {
    result in [0 .. updatesNo() - 1] and
    index = initializersNo() + result
  }

  override Instruction getFirstInstruction() {
    if this.hasInitialization()
    then result = this.getDeclAndInit(0).getFirstInstruction()
    else result = this.getFirstConditionInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = this.getDeclAndInit(index) and
      index < initializersNo() - 1 and
      result = this.getDeclAndInit(index + 1).getFirstInstruction()
    )
    or
    child = this.getDeclAndInit(initializersNo() - 1) and
    result = this.getFirstConditionInstruction()
    or
    (
      child = this.getBody() and
      if this.hasUpdate()
      then result = this.getUpdate(0).getFirstInstruction()
      else result = this.getFirstConditionInstruction()
    )
    or
    exists(int index |
      child = this.getUpdate(index) and
      result = this.getUpdate(index + 1).getFirstInstruction()
    )
    or
    child = this.getUpdate(updatesNo() - 1) and
    result = this.getFirstConditionInstruction()
  }
}

/**
 * Base class for the translation of `BreakStmt`s and `GotoStmt`s.
 */
abstract class TranslatedSpecificJump extends TranslatedStmt {
  override Instruction getFirstInstruction() { result = this.getInstruction(OnlyInstructionTag()) }

  override TranslatedElement getChild(int id) { none() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getTargetInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  /**
   * Gets the instruction that is the target of the jump.
   */
  abstract Instruction getTargetInstruction();
}

class TranslatedBreakStmt extends TranslatedSpecificJump {
  override BreakStmt stmt;

  override Instruction getTargetInstruction() { result = getEnclosingLoopOrSwitchNextInstr(stmt) }
}

private Instruction getEnclosingLoopOrSwitchNextInstr(Stmt crtStmt) {
  if crtStmt instanceof LoopStmt or crtStmt instanceof SwitchStmt
  then result = getTranslatedStmt(crtStmt).getParent().getChildSuccessor(getTranslatedStmt(crtStmt))
  else result = getEnclosingLoopOrSwitchNextInstr(crtStmt.getParent())
}

class TranslatedContinueStmt extends TranslatedSpecificJump {
  override ContinueStmt stmt;

  override Instruction getTargetInstruction() { result = getEnclosingLoopTargetInstruction(stmt) }
}

private Instruction getEnclosingLoopTargetInstruction(Stmt crtStmt) {
  if crtStmt instanceof ForStmt
  then result = getNextForInstruction(crtStmt)
  else
    if crtStmt instanceof LoopStmt
    then result = getTranslatedStmt(crtStmt).getFirstInstruction()
    else result = getEnclosingLoopTargetInstruction(crtStmt.getParent())
}

private Instruction getNextForInstruction(ForStmt for) {
  if exists(for.getUpdate(0))
  then result = getTranslatedStmt(for).(TranslatedForStmt).getUpdate(0).getFirstInstruction()
  else
    if exists(for.getCondition())
    then result = getTranslatedStmt(for).(TranslatedForStmt).getCondition().getFirstInstruction()
    else result = getTranslatedStmt(for).(TranslatedForStmt).getBody().getFirstInstruction()
}

class TranslatedGotoLabelStmt extends TranslatedSpecificJump {
  override GotoLabelStmt stmt;

  override Instruction getTargetInstruction() {
    result = getTranslatedStmt(stmt.getTarget()).getFirstInstruction()
  }
}

class TranslatedGotoCaseStmt extends TranslatedSpecificJump {
  override GotoCaseStmt stmt;

  override Instruction getTargetInstruction() {
    result = getCase(stmt, stmt.getExpr()).getFirstInstruction()
  }
}

private TranslatedStmt getCase(Stmt crtStmt, Expr expr) {
  if crtStmt instanceof SwitchStmt
  then
    exists(CaseStmt caseStmt |
      caseStmt = crtStmt.(SwitchStmt).getACase() and
      // We check for the constant value of the expression
      // since we can't check for equality between `PatternExpr` and `Expr`
      caseStmt.getPattern().getValue() = expr.getValue() and
      result = getTranslatedStmt(caseStmt)
    )
  else result = getCase(crtStmt.getParent(), expr)
}

class TranslatedGotoDefaultStmt extends TranslatedSpecificJump {
  override GotoDefaultStmt stmt;

  override Instruction getTargetInstruction() {
    result = getDefaultCase(stmt).getFirstInstruction()
  }
}

private TranslatedStmt getDefaultCase(Stmt crtStmt) {
  if crtStmt instanceof SwitchStmt
  then
    exists(CaseStmt caseStmt |
      caseStmt = crtStmt.(SwitchStmt).getDefaultCase() and
      result = getTranslatedStmt(caseStmt)
    )
  else result = getDefaultCase(crtStmt.getParent())
}

class TranslatedSwitchStmt extends TranslatedStmt {
  override SwitchStmt stmt;

  private TranslatedExpr getSwitchExpr() { result = getTranslatedExpr(stmt.getExpr()) }

  override Instruction getFirstInstruction() { result = this.getSwitchExpr().getFirstInstruction() }

  override TranslatedElement getChild(int id) {
    if id = -1
    then
      // The switch expression.
      result = getTranslatedExpr(stmt.getChild(0))
    else
      if id = 0
      then
        // The first case's body.
        result = getTranslatedStmt(stmt.getChild(0))
      else
        // The subsequent case's bodies.
        result = getTranslatedStmt(stmt.getChild(id))
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = SwitchBranchTag() and
    opcode instanceof Opcode::Switch and
    resultType = getVoidType()
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SwitchBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = this.getSwitchExpr().getResult()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = SwitchBranchTag() and
    exists(CaseStmt caseStmt |
      caseStmt = stmt.getACase() and
      kind = this.getCaseEdge(caseStmt) and
      result = getTranslatedStmt(caseStmt).getFirstInstruction()
    )
    or
    not exists(stmt.getDefaultCase()) and
    tag = SwitchBranchTag() and
    kind instanceof DefaultEdge and
    result = getParent().getChildSuccessor(this)
  }

  private EdgeKind getCaseEdge(CaseStmt caseStmt) {
    if caseStmt instanceof DefaultCase
    then result instanceof DefaultEdge
    else
      exists(CaseEdge edge |
        result = edge and
        hasCaseEdge(caseStmt, edge.getMinValue(), edge.getMinValue())
      )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getSwitchExpr() and result = this.getInstruction(SwitchBranchTag())
    or
    exists(int index, int numStmts |
      numStmts = count(stmt.getAChild()) and
      child = getTranslatedStmt(stmt.getChild(index)) and
      if index = (numStmts - 1)
      then result = this.getParent().getChildSuccessor(this)
      else result = getTranslatedStmt(stmt.getChild(index + 1)).getFirstInstruction()
    )
  }
}

class TranslatedEnumeratorForeach extends TranslatedLoop {
  override ForeachStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getTempEnumDecl()
    or
    id = 1 and result = getTry()
  }

  override Instruction getFirstInstruction() { result = getTempEnumDecl().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getTempEnumDecl() and
    result = getTry().getFirstInstruction()
    or
    child = getTry() and
    result = getParent().getChildSuccessor(this)
  }

  private TranslatedElement getTry() { result = ForeachElements::getTry(stmt) }

  private TranslatedElement getTempEnumDecl() { result = ForeachElements::getEnumDecl(stmt) }
}

class TranslatedUnsafeStmt extends TranslatedStmt {
  override UnsafeStmt stmt;

  override TranslatedElement getChild(int id) { id = 0 and result = this.getBlock() }

  override Instruction getFirstInstruction() { result = this.getBlock().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getBlock() and
    result = this.getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  private TranslatedStmt getBlock() { result = getTranslatedStmt(stmt.getBlock()) }
}

// TODO: does not reflect the fixed part, just treats the stmt
//       as some declarations followed by the body
class TranslatedFixedStmt extends TranslatedStmt {
  override FixedStmt stmt;

  override TranslatedElement getChild(int id) {
    result = getDecl(id)
    or
    id = noDecls() and result = this.getBody()
  }

  override Instruction getFirstInstruction() { result = this.getDecl(0).getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = this.getDecl(id) and
      id < this.noDecls() - 1 and
      result = this.getDecl(id + 1).getFirstInstruction()
    )
    or
    child = this.getDecl(this.noDecls() - 1) and result = this.getBody().getFirstInstruction()
    or
    child = this.getBody() and result = this.getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  private TranslatedLocalDeclaration getDecl(int id) {
    result = getTranslatedLocalDeclaration(stmt.getVariableDeclExpr(id))
  }

  private int noDecls() { result = count(stmt.getAVariableDeclExpr()) }

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getBody()) }
}

class TranslatedLockStmt extends TranslatedStmt {
  override LockStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getLockedVarDecl()
    or
    id = 1 and result = getLockWasTakenDecl()
    or
    id = 2 and result = getTry()
  }

  override Instruction getFirstInstruction() { result = getLockedVarDecl().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getLockedVarDecl() and
    result = getLockWasTakenDecl().getFirstInstruction()
    or
    child = getLockWasTakenDecl() and
    result = getTry().getFirstInstruction()
    or
    child = getTry() and
    result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  private TranslatedElement getTry() { result = LockElements::getTry(stmt) }

  private TranslatedElement getLockedVarDecl() { result = LockElements::getLockedVarDecl(stmt) }

  private TranslatedElement getLockWasTakenDecl() {
    result = LockElements::getLockWasTakenDecl(stmt)
  }
}

// TODO: Should be modeled using the desugaring framework for a
//       more exact translation.
class TranslatedCheckedUncheckedStmt extends TranslatedStmt {
  TranslatedCheckedUncheckedStmt() {
    stmt instanceof CheckedStmt or
    stmt instanceof UncheckedStmt
  }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getBody() }

  override Instruction getFirstInstruction() { result = this.getBody().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getBody() and
    result = this.getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  private TranslatedElement getBody() {
    result = getTranslatedStmt(stmt.(CheckedStmt).getBlock()) or
    result = getTranslatedStmt(stmt.(UncheckedStmt).getBlock())
  }
}

// TODO: Should be modeled using the desugaring framework for a
//       more exact translation.
class TranslatedUsingBlockStmt extends TranslatedStmt {
  override UsingBlockStmt stmt;

  override TranslatedElement getChild(int id) {
    result = getDecl(id)
    or
    id = getNumberOfDecls() and result = this.getBody()
  }

  override Instruction getFirstInstruction() {
    if getNumberOfDecls() > 0
    then result = this.getDecl(0).getFirstInstruction()
    else result = this.getBody().getFirstInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = this.getDecl(id) and
      result = this.getDecl(id + 1).getFirstInstruction()
    )
    or
    child = this.getDecl(this.getNumberOfDecls() - 1) and
    result = this.getBody().getFirstInstruction()
    or
    child = this.getBody() and result = this.getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  private TranslatedLocalDeclaration getDecl(int id) {
    result = getTranslatedLocalDeclaration(stmt.getVariableDeclExpr(id))
  }

  private int getNumberOfDecls() { result = count(stmt.getAVariableDeclExpr()) }

  private TranslatedStmt getBody() { result = getTranslatedStmt(stmt.getBody()) }
}

// TODO: Should be modeled using the desugaring framework for a
//       more exact translation.
class TranslatedUsingDeclStmt extends TranslatedStmt {
  override UsingDeclStmt stmt;

  override TranslatedElement getChild(int id) { result = getDecl(id) }

  override Instruction getFirstInstruction() { result = this.getDecl(0).getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = this.getDecl(id) and
      id < this.noDecls() - 1 and
      result = this.getDecl(id + 1).getFirstInstruction()
    )
    or
    child = this.getDecl(this.noDecls() - 1) and result = this.getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  private TranslatedLocalDeclaration getDecl(int id) {
    result = getTranslatedLocalDeclaration(stmt.getVariableDeclExpr(id))
  }

  private int noDecls() { result = count(stmt.getAVariableDeclExpr()) }
}
