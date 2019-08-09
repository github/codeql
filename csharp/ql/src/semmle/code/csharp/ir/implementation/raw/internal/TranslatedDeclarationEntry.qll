import csharp
private import semmle.code.csharp.ir.implementation.Opcode
private import semmle.code.csharp.ir.internal.IRUtilities
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedInitialization
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

/**
 * Gets the `TranslatedDeclarationEntry` that represents the declaration
 * `entry`.
 */
TranslatedLocalDeclaration getTranslatedLocalDeclaration(LocalVariableDeclExpr declExpr) {
  result.getAST() = declExpr
}

/**
 * Represents the IR translation of a declaration within the body of a function.
 */
abstract class TranslatedLocalDeclaration extends TranslatedElement, TTranslatedDeclarationEntry {
  LocalVariableDeclExpr expr;

  TranslatedLocalDeclaration() {
    this = TTranslatedDeclarationEntry(expr)
  }

  override final Callable getFunction() {
    result = expr.getEnclosingCallable()
  }

  override final string toString() {
    result = expr.toString()
  }

  override final Language::AST getAST() {
    result = expr
  }
}

/**
 * Represents the IR translation of the declaration of a local variable,
 * including its initialization, if any.
 */
class TranslatedLocalVariableDeclaration extends TranslatedLocalDeclaration, 
    InitializationContext {
  LocalVariable var;
  
  TranslatedLocalVariableDeclaration() {
    var = expr.getVariable()
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
      tag = InitializerVariableAddressTag() and
      opcode instanceof Opcode::VariableAddress and
      resultType = getVariableType(var) and
      isLValue = true
    ) or
    (
      hasUninitializedInstruction() and
      tag = InitializerStoreTag() and
      opcode instanceof Opcode::Uninitialized and
      resultType = getVariableType(var) and
      isLValue = false
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    (
      tag = InitializerVariableAddressTag() and
      kind instanceof GotoEdge and
      
      if hasUninitializedInstruction() then
        result = getInstruction(InitializerStoreTag())
      else
        if isInitializedByExpr() then
          // initialization is done by the expression
          result = getParent().getChildSuccessor(this)
        else
          result = getInitialization().getFirstInstruction()
    ) or
    (
      hasUninitializedInstruction() and
      kind instanceof GotoEdge and
      tag = InitializerStoreTag() and
      (
        result = getInitialization().getFirstInstruction() or
        not exists(getInitialization()) and result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and result = getParent().getChildSuccessor(this)
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerVariableAddressTag() or
      hasUninitializedInstruction() and tag = InitializerStoreTag()
    ) and
    result = getIRUserVariable(getFunction(), var)
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    hasUninitializedInstruction() and
    tag = InitializerStoreTag() and
    operandTag instanceof AddressOperandTag and
    result = getInstruction(InitializerVariableAddressTag())
  }

  override Instruction getTargetAddress() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() {
    result = getVariableType(var)
  }

  // TODO: All declarations which use an initializer will need a special case here
  private TranslatedInitialization getInitialization() {
    // First complex initializations
    if (var.getInitializer() instanceof ArrayCreation) then
      result = getTranslatedInitialization(var.getInitializer().(ArrayCreation).getInitializer())
    else if (var.getInitializer() instanceof ObjectCreation) then
      result = getTranslatedInitialization(var.getInitializer())   
    else // then the simple variable initialization
      result = getTranslatedInitialization(var.getInitializer())
  }

  private predicate hasUninitializedInstruction() {
    (
      not exists(getInitialization()) or
      getInitialization() instanceof TranslatedListInitialization
    ) and
    not isInitializedByExpr()
  }
  
  /**
   * Predicate that holds if a declaration is not explicitly initialized,
   * but will be initialized as part of an expression.
   */
  private predicate isInitializedByExpr() {
    expr.getParent() instanceof IsExpr
  }
}

///**
// * Gets the `TranslatedRangeBasedForVariableDeclaration` that represents the declaration of
// * `var`.
// */
//TranslatedRangeBasedForVariableDeclaration getTranslatedRangeBasedForVariableDeclaration(
//    LocalVariable var) {
//  result.getVariable() = var
//}

///**
// * Represents the IR translation of a compiler-generated variable in a range-based `for` loop.
// */
//class TranslatedRangeBasedForVariableDeclaration extends TranslatedVariableDeclaration,
//    TTranslatedRangeBasedForVariableDeclaration {
//  RangeBasedForStmt forStmt;
//  LocalVariable var;
//
//  TranslatedRangeBasedForVariableDeclaration() {
//    this = TTranslatedRangeBasedForVariableDeclaration(forStmt, var)
//  }
//
//  override string toString() {
//    result = var.toString()
//  }
//
//  override Locatable getAST() {
//    result = var
//  }
//
//  override Function getFunction() {
//    result = forStmt.getEnclosingFunction()
//  }
//
//  override LocalVariable getVariable() {
//    result = var
//  }
//}

//TranslatedConditionDecl getTranslatedConditionDecl(ConditionDeclExpr expr) {
//  result.getAST() = expr
//}

///**
// * Represents the IR translation of the declaration portion of a `ConditionDeclExpr`, which
// * represents the variable declared in code such as:
// * ```
// * if (int* p = &x) {
// * }
// * ```
// */
//class TranslatedConditionDecl extends TranslatedVariableDeclaration, TTranslatedConditionDecl {
//  ConditionDeclExpr conditionDeclExpr;
//
//  TranslatedConditionDecl() {
//    this = TTranslatedConditionDecl(conditionDeclExpr)
//  }
//
//  override string toString() {
//    result = "decl: " + conditionDeclExpr.toString()
//  }
//
//  override Locatable getAST() {
//    result = conditionDeclExpr
//  }
//
//  override Function getFunction() {
//    result = conditionDeclExpr.getEnclosingFunction()
//  }
//
//  override LocalVariable getVariable() {
//    result = conditionDeclExpr.getVariable()
//  }
//}
