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

//TODO: Reason about constructors and destructors

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
    id = -3 and result = getConstructorInitList() or
    id = -2 and result = getBody() or
    id = -1 and result = getDestructorDestructionList() or
    id >= 0 and result = getParameter(id)
  }

  private final TranslatedConstructorInitList getConstructorInitList() {
    result = getTranslatedConstructorInitList(callable)
  }
  
  private final TranslatedDestructorDestructionList getDestructorDestructionList() {
    result = getTranslatedDestructorDestructionList(callable)
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
          result = getConstructorInitList().getFirstInstruction()
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
        result = getConstructorInitList().getFirstInstruction()
    ) or
    (
      child = getConstructorInitList() and
      result = getBody().getFirstInstruction()
    ) or 
    (
      child = getBody() and
      result = getReturnSuccessorInstruction()
    ) or
    (
      child = getDestructorDestructionList() and
      if getReturnType() instanceof VoidType then
        result = getInstruction(ReturnTag())
      else
        result = getInstruction(ReturnValueAddressTag())
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
        // TODO: UnknownType seems to break it.
        //       For now, in the context of C#, ObjectType seems sensible.
        resultType instanceof ObjectType and
        isLValue = false
      ) or
      (
        tag = AliasedDefinitionTag() and
        opcode instanceof Opcode::AliasedDefinition and
        // TODO: UnknownType seems to break it.
        //       For now, in the context of C#, ObjectType seems sensible.
        resultType instanceof ObjectType and
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
          exists(ThrowExpr throw |
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
    result = param.getCallable() // or
    // result = param.getCatchBlock().getEnclosingFunction()
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

private TranslatedConstructorInitList 
getTranslatedConstructorInitList(Callable callable) {
  result.getAST() = callable
}

/**
 * Represents the IR translation of a constructor initializer list. To simplify
 * the implementation of `TranslatedFunction`, a `TranslatedConstructorInitList`
 * exists for every function, not just for constructors. Of course, only the
 * instances for constructors can actually contain initializers.
 */
class TranslatedConstructorInitList extends TranslatedElement,
  InitializationContext, TTranslatedConstructorInitList {
  Callable callable;

  TranslatedConstructorInitList() {
    this = TTranslatedConstructorInitList(callable)
  }

  override string toString() {
    result = "ctor init: " + callable.toString()
  }

  override Language::AST getAST() {
    result = callable
  }

  // TODO: Is this enough?
  override TranslatedElement getChild(int id) {
    result = getTranslatedExpr(callable).getChild(id)
//    exists(MemberInitializer init |
//      init = callable.(Constructor).getInitializer().getRawArgument(id) and
//      result = getTranslatedConstructorFieldInitialization(init)
//    ) // or
//    exists(ConstructorBaseInit baseInit |
//      baseInit = callable.(Constructor).getInitializer().getRawArgument(id) and
//      result = getTranslatedConstructorBaseInit(baseInit)
//    )
  }

  override Instruction getFirstInstruction() {
    if exists(getChild(0)) then
      result = getChild(0).getFirstInstruction()
    else
      result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    none()
  }

  override Callable getFunction() {
    result = callable
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = getChild(id) and
      if exists(getChild(id + 1)) then
        result = getChild(id + 1).getFirstInstruction()
      else
        result = getParent().getChildSuccessor(this)
    )
  }

  override Instruction getTargetAddress() {
    result = getTranslatedFunction(callable).getInitializeThisInstruction()
  }

  override Type getTargetType() {
    result = getTranslatedFunction(callable).getThisType()
  }
}

private TranslatedDestructorDestructionList 
getTranslatedDestructorDestructionList(Callable callable) {
  result.getAST() = callable
}

// TODO: Should not exist in C#, keep for now (the fix for getReturnSuccessorInstruction replaces it)
/**
 * Represents the IR translation of a destructor's implicit calls to destructors
 * for fields and base classes. To simplify the implementation of `TranslatedFunction`, 
 * a `TranslatedDestructorDestructionList` exists for every function, not just for
 * destructors. Of course, only the instances for destructors can actually contain
 * destructions.
 */
class TranslatedDestructorDestructionList extends TranslatedElement,
  TTranslatedDestructorDestructionList {
  Callable callable;

  TranslatedDestructorDestructionList() {
    this = TTranslatedDestructorDestructionList(callable)
  }

  override string toString() {
    result = "dtor destruction: " + callable.toString()
  }

  override Language::AST getAST() {
    result = callable
  }

  // TODO: Is this enough?
  override TranslatedElement getChild(int id) {
     result = getTranslatedExpr(callable).getChild(id)
  }

  override Instruction getFirstInstruction() {
    if exists(getChild(0)) then
      result = getChild(0).getFirstInstruction()
    else
      result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    none()
  }

  override Callable getFunction() {
    result = callable
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = getChild(id) and
      if exists(getChild(id + 1)) then
        result = getChild(id + 1).getFirstInstruction()
      else
        result = getParent().getChildSuccessor(this)
    )
  }
}
