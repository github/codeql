import csharp
private import semmle.code.csharp.ir.internal.TempVariableTag
private import semmle.code.csharp.ir.internal.OperandTag
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

  override final Callable getCallable() {
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
class TranslatedTryStmt extends TranslatedStmt {
  override TryStmt stmt;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getBody() or
    result = getHandler(id - 1)
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
      handler = getHandler(count(stmt.getACatchClause())) and
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
  	// body stmt of try is 0th child
    result = getTranslatedStmt(stmt.getChild(0))
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
 * The IR translation of a C++ `catch` handler.
 */
abstract class TranslatedHandler extends TranslatedStmt {
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

// TODO: Fix specific catch
///**
// * The IR translation of a C++ `catch` block that catches an exception with a
// * specific type (e.g. `catch (const std::exception&)`).
// */
//class TranslatedCatchByTypeHandler extends TranslatedHandler {
//  TranslatedCatchByTypeHandler() {
//    stmt instanceof SpecificCatchClause
//  }
//
//  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
//    Type resultType, boolean isLValue) {
//    tag = CatchTag() and
//    opcode instanceof Opcode::CatchByType and
//    resultType instanceof VoidType and
//    isLValue = false
//  }
//
//  override TranslatedElement getChild(int id) {
//    result = super.getChild(id) or
//    id = 0 and result = getParameter()
//  }
//
//  override Instruction getChildSuccessor(TranslatedElement child) {
//    result = super.getChildSuccessor(child) or
//    child = getParameter() and result = getBlock().getFirstInstruction()
//  }
//
//  override Instruction getInstructionSuccessor(InstructionTag tag,
//    EdgeKind kind) {
//    tag = CatchTag() and
//    (
//      (
//        kind instanceof GotoEdge and
//        result = getParameter().getFirstInstruction()
//      ) or
//      (
//        kind instanceof ExceptionEdge and
//        result = getParent().(TranslatedTryStmt).getNextHandler(this)
//      )
//    )
//  }
//
//  override Type getInstructionExceptionType(InstructionTag tag) {
//    tag = CatchTag() and
//    result = stmt.(SpecificCatchClause).getVariable().getType()
//  }
//
//// TODO: Fix the getParameter() method (C++ sees the catch var as a parameter, C# sees it as a var)
////  private TranslatedParameter getParameter() {
////    result = getTranslatedParameter(stmt.(SpecificCatchClause).getVariable())
////  }
//}

/**
 * The IR translation of a C++ `catch (...)` block.
 */
class TranslatedCatchAnyHandler extends TranslatedHandler {
  TranslatedCatchAnyHandler() {
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

  // In the C++ implementation ReturnStmt and JumpStmt have no relationship
  // In C# the ReturnStmt is a subclass of JumpStmt, so we will discard it for now
  TranslatedJumpStmt() {
  	not (stmt instanceof ReturnStmt)
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
    // TODO: FIX THE SUCCESSOR INSTRUCTION
    result = getTranslatedStmt(stmt).getInstructionSuccessor(tag, kind)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
}

// TODO: Fix Switch stmts
//class TranslatedSwitchStmt extends TranslatedStmt {
//  override SwitchStmt stmt;
//
//  private TranslatedExpr getExpr() {
//    result = getTranslatedExpr(stmt.getExpr())
//  }
//
//  private TranslatedStmt getBody() {
//    result = getTranslatedStmt(stmt.getBody())
//  }
//
//  override Instruction getFirstInstruction() {
//    result = getExpr().getFirstInstruction()
//  }
//
//  override TranslatedElement getChild(int id) {
//    id = 0 and result = getExpr() or
//    id = 1 and result = getBody()
//  }
//
//  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
//    Type resultType, boolean isLValue) {
//    tag = SwitchBranchTag() and
//    opcode instanceof Opcode::Switch and
//    resultType instanceof VoidType and
//    isLValue = false
//  }
//
//  override Instruction getInstructionOperand(InstructionTag tag,
//      OperandTag operandTag) {
//    tag = SwitchBranchTag() and
//    operandTag instanceof ConditionOperandTag and
//    result = getExpr().getResult()
//  }
//
//  override Instruction getInstructionSuccessor(InstructionTag tag,
//    EdgeKind kind) {
//    tag = SwitchBranchTag() and
//    exists(CaseStmt caseStmt |
//      caseStmt = stmt.getACase() and
//      kind = getCaseEdge(caseStmt) and
//      result = getTranslatedStmt(caseStmt).getFirstInstruction()
//    )
//  }
//
//  override Instruction getChildSuccessor(TranslatedElement child) {
//    child = getExpr() and result = getInstruction(SwitchBranchTag()) or
//    child = getBody() and result = getParent().getChildSuccessor(this)
//  }
//}