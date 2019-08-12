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
