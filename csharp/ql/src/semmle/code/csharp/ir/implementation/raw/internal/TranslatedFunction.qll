import csharp
import semmle.code.csharp.ir.implementation.raw.IR
private import semmle.code.csharp.ir.implementation.Opcode
private import semmle.code.csharp.ir.internal.IRUtilities
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import semmle.code.csharp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedInitialization
private import TranslatedStmt
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

/**
 * Gets the `TranslatedFunction` that represents function `callable`.
 */
TranslatedFunction getTranslatedFunction(Callable callable) {
  result.getAST() = callable
}

/**
 * Represents the IR translation of a function. This is the root elements for
 * all other elements associated with this function.
 */
class TranslatedFunction extends TranslatedElement,
  TTranslatedFunction {
  Callable callable;

  TranslatedFunction() {
    this = TTranslatedFunction(callable)
  }

  override final string toString() {
    result = callable.toString()
  }

  override final Language::AST getAST() {
    result = callable
  }

  /**
   * Gets the function being translated.
   */
  override final Callable getFunction() {
    result = callable
  }

  override final TranslatedElement getChild(int id) {
    id = -2 and result = getConstructorInitializer() or
    id = -1 and result = getBody() or
    id >= 0 and result = getParameter(id)
  }

  private final TranslatedConstructorInitializer getConstructorInitializer() {
    exists(ConstructorInitializer ci |
           ci = callable.getAChild() and
           result = getTranslatedConstructorInitializer(ci)) 
  }

  private final TranslatedStmt getBody() {
    result = getTranslatedStmt(callable.getBody())
  }

  private final TranslatedParameter getParameter(int index) {
    result = getTranslatedParameter(callable.getParameter(index))
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(EnterFunctionTag())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = EnterFunctionTag() and
        result = getInstruction(AliasedDefinitionTag())
      ) or (
        tag = AliasedDefinitionTag() and
        result = getInstruction(UnmodeledDefinitionTag())
      ) or
      (
        tag = UnmodeledDefinitionTag() and
        if exists(getThisType()) then
          result = getInstruction(InitializeThisTag())
        else if exists(getParameter(0)) then
          result = getParameter(0).getFirstInstruction()
        else
          result = getBody().getFirstInstruction()
      ) or
      (
        tag = InitializeThisTag() and
        if exists(getParameter(0)) then
          result = getParameter(0).getFirstInstruction()
        else
          if (exists(getConstructorInitializer())) then
            result = getConstructorInitializer().getFirstInstruction()
          else
            result = getBody().getFirstInstruction()
      ) or
      (
        tag = ReturnValueAddressTag() and
        result = getInstruction(ReturnTag())
      ) or
      (
        tag = ReturnTag() and
        result = getInstruction(UnmodeledUseTag())
      ) or
      (
        tag = UnwindTag() and
        result = getInstruction(UnmodeledUseTag())
      ) or
      (
        tag = UnmodeledUseTag() and
        result = getInstruction(ExitFunctionTag())
      )
    )
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    exists(int paramIndex |
      child = getParameter(paramIndex) and
      if exists(callable.getParameter(paramIndex + 1)) then
        result = getParameter(paramIndex + 1).getFirstInstruction()
      else
        if (exists(getConstructorInitializer())) then
          result = getConstructorInitializer().getFirstInstruction()
        else
          result = getBody().getFirstInstruction()
    ) or
    (
      child = getConstructorInitializer() and
      result = getBody().getFirstInstruction()
    ) or 
    (
      child = getBody() and
      result = getReturnSuccessorInstruction()
    )
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    (
      (
        tag = EnterFunctionTag() and
        opcode instanceof Opcode::EnterFunction and
        resultType instanceof VoidType and
        isLValue = false
      ) or
      (
        tag = UnmodeledDefinitionTag() and
        opcode instanceof Opcode::UnmodeledDefinition and
        resultType instanceof Language::UnknownType and
        isLValue = false
      ) or
      (
        tag = AliasedDefinitionTag() and
        opcode instanceof Opcode::AliasedDefinition and
        resultType instanceof Language::UnknownType and
        isLValue = false
      ) or
      (
        tag = InitializeThisTag() and
        opcode instanceof Opcode::InitializeThis and
        resultType = getThisType() and
        isLValue = true
      ) or
      (
        tag = ReturnValueAddressTag() and
        opcode instanceof Opcode::VariableAddress and
        resultType = getReturnType() and
        not resultType instanceof VoidType and
        isLValue = true
      ) or
      (
        tag = ReturnTag() and
        resultType instanceof VoidType and
        isLValue = false and
        if getReturnType() instanceof VoidType then
          opcode instanceof Opcode::ReturnVoid
        else
          opcode instanceof Opcode::ReturnValue
      ) or
      (
        tag = UnwindTag() and
        opcode instanceof Opcode::Unwind and
        resultType instanceof VoidType and
        isLValue = false and
        (
          // Only generate the `Unwind` instruction if there is any exception
          // handling present in the function.
          exists(TryStmt try |
            try.getEnclosingCallable() = callable
          ) or
          exists(ThrowStmt throw |
            throw.getEnclosingCallable() = callable
          )
        )
      ) or
      (
        tag = UnmodeledUseTag() and
        opcode instanceof Opcode::UnmodeledUse and
        resultType instanceof VoidType and
        isLValue = false
      ) or
      (
        tag = ExitFunctionTag() and
        opcode instanceof Opcode::ExitFunction and
        resultType instanceof VoidType and
        isLValue = false
      )
    )
  }

  override final Instruction getExceptionSuccessorInstruction() {
    result = getInstruction(UnwindTag()) 
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    (
      tag = UnmodeledUseTag() and
      operandTag instanceof UnmodeledUseOperandTag and
      result.getEnclosingFunction() = callable and
      result.hasMemoryResult()
    ) or
    (
      tag = UnmodeledUseTag() and
      operandTag instanceof UnmodeledUseOperandTag and
      result = getUnmodeledDefinitionInstruction()
    ) or
    (
      tag = ReturnTag() and
      not getReturnType() instanceof VoidType and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getInstruction(ReturnValueAddressTag())
        ) or
        (
          operandTag instanceof LoadOperandTag and
          result = getUnmodeledDefinitionInstruction()
        )
      )
    )
  }

  override final Type getInstructionOperandType(InstructionTag tag,
      TypedOperandTag operandTag) {
    tag = ReturnTag() and
    not getReturnType() instanceof VoidType and
    operandTag instanceof LoadOperandTag and
    result = getReturnType()
  }
  
  override final IRVariable getInstructionVariable(InstructionTag tag) {
    tag = ReturnValueAddressTag() and
    result = getReturnVariable()
  }

  override final predicate hasTempVariable(TempVariableTag tag, Type type) {
    tag = ReturnValueTempVar() and
    type = getReturnType() and
    not type instanceof VoidType
  }

  /**
   * Gets the instruction to which control should flow after a `return`
   * statement. In C#, this should be the instruction which generates `VariableAddress[#return]`.
   */
  final Instruction getReturnSuccessorInstruction() {
      if getReturnType() instanceof VoidType then
        result = getInstruction(ReturnTag())
      else
        result = getInstruction(ReturnValueAddressTag())
  }

  /**
   * Gets the variable that represents the return value of this function.
   */
  final IRReturnVariable getReturnVariable() {
    result = getIRTempVariable(callable, ReturnValueTempVar())
  }

  /**
   * Gets the single `UnmodeledDefinition` instruction for this function.
   */
  final Instruction getUnmodeledDefinitionInstruction() {
    result = getInstruction(UnmodeledDefinitionTag())
  }

  /**
   * Gets the single `InitializeThis` instruction for this function. Holds only
   * if the function is an instance member function, constructor, or destructor.
   */
  final Instruction getInitializeThisInstruction() {
    result = getInstruction(InitializeThisTag())
  }
  
  /**
   * Gets the type pointed to by the `this` pointer for this function (i.e. `*this`).
   * Holds only if the function is an instance member function, constructor, or destructor.
   */
  final Type getThisType() {
    result = callable.getDeclaringType()
  }

  /**
   * Holds if this function defines or accesses variable `var` with type `type`. This includes all
   * parameters and local variables, plus any static fields that are directly accessed by the
   * function.
   */
  final predicate hasUserVariable(Variable var, Type type) {
    (
      (
        var.(Member).isStatic() and
        exists(VariableAccess access |
          access.getTarget() = var and
          access.getEnclosingCallable() = callable
        )
      ) or
      var.(LocalScopeVariable).getCallable() = callable
    ) and
    type = getVariableType(var)
  }

  private final Type getReturnType() {
    result = callable.getReturnType()
  }
}

/**
 * Gets the `TranslatedParameter` that represents parameter `param`.
 */
TranslatedParameter getTranslatedParameter(Parameter param) {
  result.getAST() = param
}

/**
 * Represents the IR translation of a function parameter, including the
 * initialization of that parameter with the incoming argument.
 */
class TranslatedParameter extends TranslatedElement, TTranslatedParameter {
  Parameter param;

  TranslatedParameter() {
    this = TTranslatedParameter(param)
  }

  override final string toString() {
    result = param.toString()
  }

  override final Language::AST getAST() {
    result = param
  }

  override final Callable getFunction() {
    result = param.getCallable()
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override final TranslatedElement getChild(int id) {
    none()
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = InitializerVariableAddressTag() and
        result = getInstruction(InitializerStoreTag())
      ) or
      (
        tag = InitializerStoreTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
      none()
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    (
      tag = InitializerVariableAddressTag() and
      opcode instanceof Opcode::VariableAddress and
      resultType = getVariableType(param) and
      isLValue = true
    ) or
    (
      tag = InitializerStoreTag() and
      opcode instanceof Opcode::InitializeParameter and
      resultType = getVariableType(param) and
      isLValue = false
    )
  }

  override final IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerStoreTag() or
      tag = InitializerVariableAddressTag()
    ) and
    result = getIRUserVariable(getFunction(), param)
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      (
        operandTag instanceof AddressOperandTag and
        result = getInstruction(InitializerVariableAddressTag())
      )
    )
  }
}
