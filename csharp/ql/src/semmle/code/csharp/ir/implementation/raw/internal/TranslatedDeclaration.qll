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
 * Gets the `TranslatedDeclaration` that represents the declaration
 * `entry`.
 */
TranslatedLocalDeclaration getTranslatedLocalDeclaration(LocalVariableDeclExpr declExpr) {
  result.getAST() = declExpr
}

/**
 * Represents the IR translation of a declaration within the body of a function.
 */
abstract class TranslatedLocalDeclaration extends TranslatedElement, TTranslatedDeclaration {
  LocalVariableDeclExpr expr;

  TranslatedLocalDeclaration() { this = TTranslatedDeclaration(expr) }

  final override Callable getFunction() { result = expr.getEnclosingCallable() }

  final override string toString() { result = expr.toString() }

  final override Language::AST getAST() { result = expr }
}

/**
 * Represents the IR translation of the declaration of a local variable,
 * including its initialization, if any.
 */
class TranslatedLocalVariableDeclaration extends TranslatedLocalDeclaration, InitializationContext {
  LocalVariable var;

  TranslatedLocalVariableDeclaration() { var = expr.getVariable() }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getInitialization() }

  override Instruction getFirstInstruction() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getVariableType(var) and
    isLValue = true
    or
    this.hasUninitializedInstruction() and
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Uninitialized and
    resultType = getVariableType(var) and
    isLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    (
      tag = InitializerVariableAddressTag() and
      kind instanceof GotoEdge and
      if this.hasUninitializedInstruction()
      then result = this.getInstruction(InitializerStoreTag())
      else
        if this.isInitializedByExpr()
        then
          // initialization is done by the expression
          result = this.getParent().getChildSuccessor(this)
        else result = this.getInitialization().getFirstInstruction()
    )
    or
    this.hasUninitializedInstruction() and
    kind instanceof GotoEdge and
    tag = InitializerStoreTag() and
    (
      result = this.getInitialization().getFirstInstruction()
      or
      not exists(this.getInitialization()) and result = this.getParent().getChildSuccessor(this)
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getInitialization() and result = this.getParent().getChildSuccessor(this)
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerVariableAddressTag()
      or
      this.hasUninitializedInstruction() and tag = InitializerStoreTag()
    ) and
    result = getIRUserVariable(getFunction(), var)
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    this.hasUninitializedInstruction() and
    tag = InitializerStoreTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override Instruction getTargetAddress() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() { result = getVariableType(var) }

  private TranslatedInitialization getInitialization() {
    // First complex initializations
    if var.getInitializer() instanceof ArrayCreation
    then result = getTranslatedInitialization(var.getInitializer().(ArrayCreation).getInitializer())
    else
      if var.getInitializer() instanceof ObjectCreation
      then result = getTranslatedInitialization(var.getInitializer())
      else
        // then the simple variable initialization
        result = getTranslatedInitialization(var.getInitializer())
  }

  private predicate hasUninitializedInstruction() {
    (
      not exists(this.getInitialization()) or
      this.getInitialization() instanceof TranslatedListInitialization
    ) and
    not this.isInitializedByExpr()
  }

  /**
   * Predicate that holds if a declaration is not explicitly initialized,
   * but will be initialized as part of an expression.
   */
  private predicate isInitializedByExpr() { expr.getParent() instanceof IsExpr }
}
