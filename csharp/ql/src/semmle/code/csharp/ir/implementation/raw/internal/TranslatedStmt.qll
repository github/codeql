import csharp
private import semmle.code.csharp.ir.internal.TempVariableTag
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedDeclarationEntry
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction
private import TranslatedInitialization
private import IRInternal
private import semmle.code.csharp.ir.internal.IRUtilities

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

  override final Language::AST getAST() {
    result = stmt
  }

  override final Callable getFunction() {
    result = stmt.getEnclosingCallable()
  }
}

class TranslatedEmptyStmt extends TranslatedStmt {
  TranslatedEmptyStmt() {
    stmt instanceof EmptyStmt or
    stmt instanceof LabelStmt or
    stmt instanceof CaseStmt
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType instanceof VoidType and
    isLValue = false
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
  override LocalVariableDeclStmt stmt;

  override TranslatedElement getChild(int id) {
    result = getDeclarationEntry(id)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getDeclarationEntry(0).getFirstInstruction() //REVIEW: Empty?
  }

  private int getChildCount() {
    result = count(stmt.getAVariableDeclExpr())
  }

  private TranslatedDeclarationEntry getDeclarationEntry(int index) {
    result = getTranslatedDeclarationEntry(stmt.getVariableDeclExpr(index).getVariable())
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
    result = getTranslatedExpr(stmt.(ExprStmt).getExpr())
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getExpr()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
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
    result = getTranslatedFunction(stmt.getEnclosingCallable())
  }
}

class TranslatedReturnValueStmt extends TranslatedReturnStmt,
  InitializationContext {
  TranslatedReturnValueStmt() {
    exists(stmt.getExpr())
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getEnclosingFunction().getReturnVariable().getType() and
    isLValue = true
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
      stmt.getExpr())
  }
}

class TranslatedReturnVoidStmt extends TranslatedReturnStmt {
  TranslatedReturnVoidStmt() {
    not exists(stmt.getExpr())
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType instanceof VoidType and
    isLValue = false
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
// TODO: Make sure that if the exception is uncaught or rethrown
//       finally is still executed.
class TranslatedTryStmt extends TranslatedStmt {
  override TryStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getBody() or
    id = 1 and result = getFinally() or
    result = getCatchClause(id - 2)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
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
    child = getCatchClause(_) and result = getFinally().getFirstInstruction() or
    child = getBody() and result = getFinally().getFirstInstruction() or
    child = getFinally() and result = getParent().getChildSuccessor(this)
  }

  final Instruction getNextHandler(TranslatedClause clause) {
    exists(int index |
      clause = getCatchClause(index) and
      result = getCatchClause(index + 1).getFirstInstruction()
    ) or
    (
      // The last catch clause flows to the exception successor of the parent
      // of the `try`, because the exception successor of the `try` itself is
      // the first catch clause.
      clause = getCatchClause(count(stmt.getACatchClause()) - 1) and
      result = getParent().getExceptionSuccessorInstruction()
    )
  }

  override final Instruction getExceptionSuccessorInstruction() {
    result = getCatchClause(0).getFirstInstruction()
  }

  private TranslatedClause getCatchClause(int index) {
    result = getTranslatedStmt(stmt.getCatchClause(index))
  }
  
  private TranslatedStmt getFinally() {
    result = getTranslatedStmt(stmt.getFinally())
  }

  private TranslatedStmt getBody() {
    result = getTranslatedStmt(stmt.getBlock())
  }
}

class TranslatedBlock extends TranslatedStmt {
  override BlockStmt stmt;

  override TranslatedElement getChild(int id) {
    result = getStmt(id)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    isEmpty() and
    opcode instanceof Opcode::NoOp and
    tag = OnlyInstructionTag() and
    resultType instanceof VoidType and
    isLValue = false
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
    result = count(stmt.getAStmt())
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
 * The IR translation of a C# `catch` clause.
 */
abstract class TranslatedClause extends TranslatedStmt {
  override CatchClause stmt;

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
 * The IR translation of a C# `catch` block that catches an exception with a
 * specific type (e.g. `catch (Exception ex) { ... }`).
 */
class TranslatedCatchByTypeClause extends TranslatedClause {
  TranslatedCatchByTypeClause() {
    stmt instanceof SpecificCatchClause
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = CatchTag() and
    opcode instanceof Opcode::CatchByType and
    resultType instanceof VoidType and
    isLValue = false
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getParameter() or
    result = super.getChild(id)
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
    result = stmt.(SpecificCatchClause).getVariable().getType()
  }

  private TranslatedDeclarationEntry getParameter() {
    result = getTranslatedDeclarationEntry(stmt.(SpecificCatchClause).getVariable())
  }
}

/**
 * The IR translation of catch block with no parameters.
 */
class TranslatedGeneralCatchClause extends TranslatedClause {
  TranslatedGeneralCatchClause() {
    stmt instanceof GeneralCatchClause
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = CatchTag() and
    opcode instanceof Opcode::CatchAny and
    resultType instanceof VoidType and
    isLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = CatchTag() and
    kind instanceof GotoEdge and
    result = getBlock().getFirstInstruction()
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
  
  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isLValue) {
    (
      tag = ThrowTag() and
      opcode instanceof Opcode::ThrowValue and
      resultType instanceof VoidType and
      isLValue = false
    )
    or
    (
      tag = InitializerVariableAddressTag() and
      opcode instanceof Opcode::VariableAddress and
      resultType = getExceptionType() and
      isLValue = true
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    (
      tag = ThrowTag() and
      kind instanceof ExceptionEdge and
      result = getParent().getExceptionSuccessorInstruction()
    )
    or
    (
      tag = InitializerVariableAddressTag() and
      result = getInitialization().getFirstInstruction() and
      kind instanceof GotoEdge
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and
    result = getInstruction(ThrowTag())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getIRTempVariable(stmt, ThrowTempVar())
  }

  
  override final predicate hasTempVariable(TempVariableTag tag, Type type) {
    tag = ThrowTempVar() and
    type = getExceptionType()
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = ThrowTag() and
    (
      (
        operandTag instanceof AddressOperandTag and
        result = getInstruction(InitializerVariableAddressTag())
      ) or
      (
        operandTag instanceof LoadOperandTag and
        result = getTranslatedFunction(stmt.getEnclosingCallable()).getUnmodeledDefinitionInstruction()
      )
    )
  }

  override final Type getInstructionOperandType(InstructionTag tag,
      TypedOperandTag operandTag) {
    tag = ThrowTag() and
    operandTag instanceof LoadOperandTag and
    result = getExceptionType()
  }

  override Instruction getTargetAddress() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() {
    result = getExceptionType()
  }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(stmt.getExpr())
  }

  private Type getExceptionType() {
    result = stmt.getExpr().getType()
  }
}

/**
 * The IR translation of a simple throw statement, ie. one that just
 * rethrows an exception.
 */
class TranslatedEmptyThrowStmt extends TranslatedStmt {
  override ThrowStmt stmt;
  
  TranslatedEmptyThrowStmt() {
    not exists(stmt.getExpr())
  }
  
  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(ThrowTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isLValue) {
    tag = ThrowTag() and
    opcode instanceof Opcode::ReThrow and
    resultType instanceof VoidType and
    isLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    tag = ThrowTag() and
    kind instanceof ExceptionEdge and
    result = getParent().getExceptionSuccessorInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
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
    result = getTranslatedCondition(stmt.getCondition())
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
    Type resultType, boolean isLValue) {
    none()
  }
}

abstract class TranslatedLoop extends TranslatedStmt, ConditionContext {
  override LoopStmt stmt;

  final TranslatedCondition getCondition() {
    result = getTranslatedCondition(stmt.getCondition())
  }

  final TranslatedStmt getBody() {
    result = getTranslatedStmt(stmt.getBody())
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
    Type resultType, boolean isLValue) {
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
    result = getTranslatedStmt(stmt.getAnInitializer().getEnclosingStmt())
  }

  private predicate hasInitialization() {
    exists(stmt.getAnInitializer())
  }
  
  TranslatedExpr getUpdate() {
    result = getTranslatedExpr(stmt.getAnUpdate())
  }

  private predicate hasUpdate() {
    exists(stmt.getAnUpdate())
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
  override JumpStmt stmt;

  // Discard jump stmts that are not jump stmts in C++ for now.
  TranslatedJumpStmt() {
  	not (
  	  stmt instanceof ReturnStmt
  	  or
  	  stmt instanceof ThrowStmt
  	)
  }
  
  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::NoOp and
    resultType instanceof VoidType and
    isLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    // Get the target of the jump
    // TODO: Make sure this is the best way to do it.
    // TODO: Does not work if the switch is the last instruction in a void function. 
    //       Maybe insert a dummy label after the switch like in C++?
    result = getTranslatedStmt(stmt.getAControlFlowNode().getASuccessor().getElement()).getFirstInstruction()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
}

class TranslatedSwitchStmt extends TranslatedStmt {
  override SwitchStmt stmt;

  private TranslatedExpr getSwitchExpr() {
    result = getTranslatedExpr(stmt.getExpr())
  }

  override Instruction getFirstInstruction() {
    result = getSwitchExpr().getFirstInstruction()
  }

  override TranslatedElement getChild(int id) {
    if (id = -1) then
        result = getTranslatedExpr(stmt.getChild(0))
    else if (id = 0) then
        result = getTranslatedStmt(stmt.getChild(0))
    else
        result = getTranslatedStmt(stmt.getChild(id))
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = SwitchBranchTag() and
    opcode instanceof Opcode::Switch and
    resultType instanceof VoidType and
    isLValue = false
  }

  override Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = SwitchBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = getSwitchExpr().getResult()
  }

  private EdgeKind getCaseEdge(CaseStmt caseStmt) {
    if caseStmt instanceof DefaultCase then 
      result instanceof DefaultEdge
    else
      exists(CaseEdge edge |
        result = edge and
        hasCaseEdge(caseStmt, edge.getMinValue(), edge.getMinValue())
      ) 
  }
  
  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = SwitchBranchTag() and
    exists(CaseStmt caseStmt |
      caseStmt = stmt.getACase() and
      kind = getCaseEdge(caseStmt) and
      result = getTranslatedStmt(caseStmt).getFirstInstruction()
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getSwitchExpr() and result = getInstruction(SwitchBranchTag()) or
    exists(int index, int numStmts |
      numStmts = count(stmt.getAChild()) and
      child = getTranslatedStmt(stmt.getChild(index)) and
      if index = (numStmts - 1) then
        result = getParent().getChildSuccessor(this)
      else
        result = getTranslatedStmt(stmt.getChild(index + 1)).getFirstInstruction()
    )
  }
}
