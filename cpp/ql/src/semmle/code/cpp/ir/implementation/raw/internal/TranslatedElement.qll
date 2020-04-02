private import cpp
import semmle.code.cpp.ir.implementation.raw.IR
private import semmle.code.cpp.ir.IRConfiguration
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedFunction
private import TranslatedStmt
private import TranslatedExpr
private import IRConstruction
private import semmle.code.cpp.models.interfaces.SideEffect

/**
 * Gets the "real" parent of `expr`. This predicate treats conversions as if
 * they were explicit nodes in the expression tree, rather than as implicit
 * nodes as in the regular AST representation.
 */
private Element getRealParent(Expr expr) {
  result = expr.getParentWithConversions()
  or
  result.(Destructor).getADestruction() = expr
}

/**
 * Holds if `expr` is a constant of a type that can be replaced directly with
 * its value in the IR. This does not include address constants as we have no
 * means to express those as QL values.
 */
predicate isIRConstant(Expr expr) { exists(expr.getValue()) }

// Pulled out to work around QL-796
private predicate isOrphan(Expr expr) { not exists(getRealParent(expr)) }

/**
 * Holds if `expr` should be ignored for the purposes of IR generation due to
 * some property of `expr` or one of its ancestors.
 */
private predicate ignoreExprAndDescendants(Expr expr) {
  // Ignore parentless expressions
  isOrphan(expr)
  or
  // Ignore the constants in SwitchCase, since their values are embedded in the
  // CaseEdge.
  getRealParent(expr) instanceof SwitchCase
  or
  // Ignore descendants of constant expressions, since we'll just substitute the
  // constant value.
  isIRConstant(getRealParent(expr))
  or
  // Only translate the initializer of a static local if it uses run-time data.
  // Otherwise the initializer does not run in function scope.
  exists(Initializer init, StaticStorageDurationVariable var |
    init = var.getInitializer() and
    not var.hasDynamicInitialization() and
    expr = init.getExpr().getFullyConverted()
  )
  or
  // Ignore descendants of `__assume` expressions, since we translated these to `NoOp`.
  getRealParent(expr) instanceof AssumeExpr
  or
  // The `DestructorCall` node for a `DestructorFieldDestruction` has a `FieldAccess`
  // node as its qualifier, but that `FieldAccess` does not have a child of its own.
  // We'll ignore that `FieldAccess`, and supply the receiver as part of the calling
  // context, much like we do with constructor calls.
  expr.getParent().(DestructorCall).getParent() instanceof DestructorFieldDestruction
  or
  exists(NewArrayExpr newExpr |
    // REVIEW: Ignore initializers for `NewArrayExpr` until we determine how to
    // represent them.
    newExpr.getInitializer().getFullyConverted() = expr
  )
  or
  // Do not translate input/output variables in GNU asm statements
  //  getRealParent(expr) instanceof AsmStmt
  //  or
  ignoreExprAndDescendants(getRealParent(expr)) // recursive case
  or
  // We do not yet translate destructors properly, so for now we ignore any
  // custom deallocator call, if present.
  exists(DeleteExpr deleteExpr | deleteExpr.getAllocatorCall() = expr)
  or
  exists(DeleteArrayExpr deleteArrayExpr | deleteArrayExpr.getAllocatorCall() = expr)
  or
  exists(BuiltInVarArgsStart vaStartExpr |
    vaStartExpr.getLastNamedParameter().getFullyConverted() = expr
  )
}

/**
 * Holds if `expr` (not including its descendants) should be ignored for the
 * purposes of IR generation.
 */
private predicate ignoreExprOnly(Expr expr) {
  exists(NewOrNewArrayExpr newExpr |
    // Ignore the allocator call, because we always synthesize it. Don't ignore
    // its arguments, though, because we use them as part of the synthesis.
    newExpr.getAllocatorCall() = expr
  )
  or
  // The extractor deliberately emits an `ErrorExpr` as the first argument to
  // the allocator call, if any, of a `NewOrNewArrayExpr`. That `ErrorExpr`
  // should not be translated.
  exists(NewOrNewArrayExpr new | expr = new.getAllocatorCall().getArgument(0))
  or
  not translateFunction(expr.getEnclosingFunction())
  or
  // We do not yet translate destructors properly, so for now we ignore the
  // destructor call. We do, however, translate the expression being
  // destructed, and that expression can be a child of the destructor call.
  exists(DeleteExpr deleteExpr | deleteExpr.getDestructorCall() = expr)
  or
  exists(DeleteArrayExpr deleteArrayExpr | deleteArrayExpr.getDestructorCall() = expr)
}

/**
 * Holds if `expr` should be ignored for the purposes of IR generation.
 */
private predicate ignoreExpr(Expr expr) {
  ignoreExprOnly(expr) or
  ignoreExprAndDescendants(expr)
}

/**
 * Holds if `func` contains an AST that cannot be translated into IR. This is mostly used to work
 * around extractor bugs. Once the relevant extractor bugs are fixed, this predicate can be removed.
 */
private predicate isInvalidFunction(Function func) {
  exists(Literal literal |
    // Constructor field inits within a compiler-generated copy constructor have a source expression
    // that is a `Literal` with no value.
    literal = func.(Constructor).getAnInitializer().(ConstructorFieldInit).getExpr() and
    not exists(literal.getValue())
  )
  or
  exists(ThisExpr thisExpr |
    // An instantiation of a member function template is not treated as a `MemberFunction` if it has
    // only non-type template arguments.
    thisExpr.getEnclosingFunction() = func and
    not func instanceof MemberFunction
  )
  or
  exists(Expr expr |
    // Expression missing a type.
    expr.getEnclosingFunction() = func and
    not exists(expr.getType())
  )
}

/**
 * Holds if `func` should be translated to IR.
 */
private predicate translateFunction(Function func) {
  not func.isFromUninstantiatedTemplate(_) and
  func.hasEntryPoint() and
  not isInvalidFunction(func) and
  exists(IRConfiguration config | config.shouldCreateIRForFunction(func))
}

/**
 * Holds if `stmt` should be translated to IR.
 */
private predicate translateStmt(Stmt stmt) { translateFunction(stmt.getEnclosingFunction()) }

/**
 * Holds if `expr` is most naturally evaluated as control flow, rather than as
 * a value.
 */
private predicate isNativeCondition(Expr expr) {
  expr instanceof BinaryLogicalOperation and
  not isIRConstant(expr)
}

/**
 * Holds if `expr` can be evaluated as either a condition or a value expression,
 * depending on context.
 */
private predicate isFlexibleCondition(Expr expr) {
  (
    expr instanceof ParenthesisExpr or
    expr instanceof NotExpr
  ) and
  usedAsCondition(expr) and
  not isIRConstant(expr)
}

/**
 * Holds if `expr` is used in a condition context, i.e. the Boolean result of
 * the expression is directly used to determine control flow.
 */
private predicate usedAsCondition(Expr expr) {
  exists(BinaryLogicalOperation op |
    op.getLeftOperand().getFullyConverted() = expr or
    op.getRightOperand().getFullyConverted() = expr
  )
  or
  exists(Loop loop | loop.getCondition().getFullyConverted() = expr)
  or
  exists(IfStmt ifStmt | ifStmt.getCondition().getFullyConverted() = expr)
  or
  exists(ConditionalExpr condExpr | condExpr.getCondition().getFullyConverted() = expr)
  or
  exists(NotExpr notExpr |
    notExpr.getOperand().getFullyConverted() = expr and
    usedAsCondition(notExpr)
  )
  or
  exists(ParenthesisExpr paren |
    paren.getExpr() = expr and
    usedAsCondition(paren)
  )
}

/**
 * Holds if `expr` has an lvalue-to-rvalue conversion that should be ignored
 * when generating IR. This occurs for conversion from an lvalue of function type
 * to an rvalue of function pointer type. The conversion is represented in the
 * AST as an lvalue-to-rvalue conversion, but the IR represents both a function
 * lvalue and a function pointer prvalue the same.
 */
private predicate ignoreLoad(Expr expr) {
  expr.hasLValueToRValueConversion() and
  (
    expr instanceof ThisExpr or
    expr instanceof FunctionAccess or
    expr.(PointerDereferenceExpr).getOperand().getFullyConverted().getType().getUnspecifiedType()
      instanceof FunctionPointerType or
    expr.(ReferenceDereferenceExpr).getExpr().getType().getUnspecifiedType() instanceof
      FunctionReferenceType
  )
}

/**
 * Holds if `expr` should have a load on it because it will be loaded as part
 * of the translation of its parent. We want to associate this load with `expr`
 * itself rather than its parent since in practical applications like data flow
 * we maintain that the value of the `x` in `x++` should be what's loaded from
 * `x`.
 */
private predicate needsLoadForParentExpr(Expr expr) {
  exists(CrementOperation crement | expr = crement.getOperand().getFullyConverted())
  or
  exists(AssignOperation ao | expr = ao.getLValue().getFullyConverted())
}

/**
 * Holds if `expr` should have a `TranslatedLoad` on it.
 */
predicate hasTranslatedLoad(Expr expr) {
  (
    expr.hasLValueToRValueConversion()
    or
    needsLoadForParentExpr(expr)
  ) and
  not ignoreExpr(expr) and
  not isNativeCondition(expr) and
  not isFlexibleCondition(expr) and
  not ignoreLoad(expr)
}

/**
 * Holds if the specified `DeclarationEntry` needs an IR translation. An IR translation is only
 * necessary for automatic local variables, or for static local variables with dynamic
 * initialization.
 */
private predicate translateDeclarationEntry(DeclarationEntry entry) {
  exists(DeclStmt declStmt, LocalVariable var |
    translateStmt(declStmt) and
    declStmt.getADeclarationEntry() = entry and
    // Only declarations of local variables need to be translated to IR.
    var = entry.getDeclaration() and
    (
      not var.isStatic()
      or
      // Ignore static variables unless they have a dynamic initializer.
      var.(StaticLocalVariable).hasDynamicInitialization()
    )
  )
}

newtype TTranslatedElement =
  // An expression that is not being consumed as a condition
  TTranslatedValueExpr(Expr expr) {
    not ignoreExpr(expr) and
    not isNativeCondition(expr) and
    not isFlexibleCondition(expr)
  } or
  // A separate element to handle the lvalue-to-rvalue conversion step of an
  // expression.
  TTranslatedLoad(Expr expr) { hasTranslatedLoad(expr) } or
  // For expressions that would not otherwise generate an instruction.
  TTranslatedResultCopy(Expr expr) {
    not ignoreExpr(expr) and
    exprNeedsCopyIfNotLoaded(expr) and
    not hasTranslatedLoad(expr)
  } or
  // An expression most naturally translated as control flow.
  TTranslatedNativeCondition(Expr expr) {
    not ignoreExpr(expr) and
    isNativeCondition(expr)
  } or
  // An expression that can best be translated as control flow given the context
  // in which it is used.
  TTranslatedFlexibleCondition(Expr expr) {
    not ignoreExpr(expr) and
    isFlexibleCondition(expr)
  } or
  // An expression that is not naturally translated as control flow, but is
  // consumed in a condition context. This element adapts the original element
  // to the condition context.
  TTranslatedValueCondition(Expr expr) {
    not ignoreExpr(expr) and
    not isNativeCondition(expr) and
    not isFlexibleCondition(expr) and
    usedAsCondition(expr)
  } or
  // An expression that is naturally translated as control flow, but is used in
  // a context where a simple value is expected. This element adapts the
  // original condition to the value context.
  TTranslatedConditionValue(Expr expr) {
    not ignoreExpr(expr) and
    isNativeCondition(expr) and
    not usedAsCondition(expr)
  } or
  // An expression used as an initializer.
  TTranslatedInitialization(Expr expr) {
    not ignoreExpr(expr) and
    (
      exists(Initializer init | init.getExpr().getFullyConverted() = expr) or
      exists(ClassAggregateLiteral initList | initList.getFieldExpr(_).getFullyConverted() = expr) or
      exists(ArrayOrVectorAggregateLiteral initList |
        initList.getElementExpr(_).getFullyConverted() = expr
      ) or
      exists(ReturnStmt returnStmt | returnStmt.getExpr().getFullyConverted() = expr) or
      exists(ConstructorFieldInit fieldInit | fieldInit.getExpr().getFullyConverted() = expr) or
      exists(NewExpr newExpr | newExpr.getInitializer().getFullyConverted() = expr) or
      exists(ThrowExpr throw | throw.getExpr().getFullyConverted() = expr) or
      exists(LambdaExpression lambda | lambda.getInitializer().getFullyConverted() = expr)
    )
  } or
  // The initialization of a field via a member of an initializer list.
  TTranslatedExplicitFieldInitialization(Expr ast, Field field, Expr expr) {
    exists(ClassAggregateLiteral initList |
      not ignoreExpr(initList) and
      ast = initList and
      expr = initList.getFieldExpr(field).getFullyConverted()
    )
    or
    exists(ConstructorFieldInit init |
      not ignoreExpr(init) and
      ast = init and
      field = init.getTarget() and
      expr = init.getExpr().getFullyConverted()
    )
  } or
  // The value initialization of a field due to an omitted member of an
  // initializer list.
  TTranslatedFieldValueInitialization(Expr ast, Field field) {
    exists(ClassAggregateLiteral initList |
      not ignoreExpr(initList) and
      ast = initList and
      initList.isValueInitialized(field)
    )
  } or
  // The initialization of an array element via a member of an initializer list.
  TTranslatedExplicitElementInitialization(ArrayOrVectorAggregateLiteral initList, int elementIndex) {
    not ignoreExpr(initList) and
    exists(initList.getElementExpr(elementIndex))
  } or
  // The value initialization of a range of array elements that were omitted
  // from an initializer list.
  TTranslatedElementValueInitialization(
    ArrayOrVectorAggregateLiteral initList, int elementIndex, int elementCount
  ) {
    not ignoreExpr(initList) and
    isFirstValueInitializedElementInRange(initList, elementIndex) and
    elementCount = getEndOfValueInitializedRange(initList, elementIndex) - elementIndex
  } or
  // The initialization of a base class from within a constructor.
  TTranslatedConstructorBaseInit(ConstructorBaseInit init) { not ignoreExpr(init) } or
  // The destruction of a base class from within a destructor.
  TTranslatedDestructorBaseDestruction(DestructorBaseDestruction destruction) {
    not ignoreExpr(destruction)
  } or
  // The destruction of a field from within a destructor.
  TTranslatedDestructorFieldDestruction(DestructorFieldDestruction destruction) {
    not ignoreExpr(destruction)
  } or
  // A statement
  TTranslatedStmt(Stmt stmt) { translateStmt(stmt) } or
  // A function
  TTranslatedFunction(Function func) { translateFunction(func) } or
  // A constructor init list
  TTranslatedConstructorInitList(Function func) { translateFunction(func) } or
  // A destructor destruction list
  TTranslatedDestructorDestructionList(Function func) { translateFunction(func) } or
  // A function parameter
  TTranslatedParameter(Parameter param) {
    exists(Function func |
      (
        func = param.getFunction() or
        func = param.getCatchBlock().getEnclosingFunction()
      ) and
      translateFunction(func)
    )
  } or
  TTranslatedEllipsisParameter(Function func) { translateFunction(func) and func.isVarargs() } or
  TTranslatedReadEffects(Function func) { translateFunction(func) } or
  // The read side effects in a function's return block
  TTranslatedReadEffect(Parameter param) {
    translateFunction(param.getFunction()) and
    exists(Type t | t = param.getUnspecifiedType() |
      t instanceof ArrayType or
      t instanceof PointerType or
      t instanceof ReferenceType
    )
  } or
  // A local declaration
  TTranslatedDeclarationEntry(DeclarationEntry entry) { translateDeclarationEntry(entry) } or
  // The dynamic initialization of a static local variable. This is a separate object from the
  // declaration entry.
  TTranslatedStaticLocalVariableInitialization(DeclarationEntry entry) {
    translateDeclarationEntry(entry) and
    entry.getDeclaration() instanceof StaticLocalVariable
  } or
  // A compiler-generated variable to implement a range-based for loop. These don't have a
  // `DeclarationEntry` in the database, so we have to go by the `Variable` itself.
  TTranslatedRangeBasedForVariableDeclaration(RangeBasedForStmt forStmt, LocalVariable var) {
    translateStmt(forStmt) and
    (
      var = forStmt.getRangeVariable() or
      var = forStmt.getBeginEndDeclaration().getADeclaration() or
      var = forStmt.getVariable()
    )
  } or
  // An allocator call in a `new` or `new[]` expression
  TTranslatedAllocatorCall(NewOrNewArrayExpr newExpr) { not ignoreExpr(newExpr) } or
  // An allocation size for a `new` or `new[]` expression
  TTranslatedAllocationSize(NewOrNewArrayExpr newExpr) { not ignoreExpr(newExpr) } or
  // The declaration/initialization part of a `ConditionDeclExpr`
  TTranslatedConditionDecl(ConditionDeclExpr expr) { not ignoreExpr(expr) } or
  // The side effects of a `Call`
  TTranslatedSideEffects(Call expr) {
    exists(TTranslatedArgumentSideEffect(expr, _, _, _)) or
    expr instanceof ConstructorCall or
    expr.getTarget() instanceof AllocationFunction
  } or // A precise side effect of an argument to a `Call`
  TTranslatedArgumentSideEffect(Call call, Expr expr, int n, boolean isWrite) {
    (
      expr = call.getArgument(n).getFullyConverted()
      or
      expr = call.getQualifier().getFullyConverted() and
      n = -1
    ) and
    (
      call.getTarget().(SideEffectFunction).hasSpecificReadSideEffect(n, _) and
      isWrite = false
      or
      call.getTarget().(SideEffectFunction).hasSpecificWriteSideEffect(n, _, _) and
      isWrite = true
      or
      not call.getTarget() instanceof SideEffectFunction and
      exists(Type t | t = expr.getUnspecifiedType() |
        t instanceof ArrayType or
        t instanceof PointerType or
        t instanceof ReferenceType
      ) and
      (
        isWrite = true or
        isWrite = false
      )
      or
      not call.getTarget() instanceof SideEffectFunction and
      n = -1 and
      (
        isWrite = true or
        isWrite = false
      )
    ) and
    not ignoreExpr(expr) and
    not ignoreExpr(call)
  }

/**
 * Gets the index of the first explicitly initialized element in `initList`
 * whose index is greater than `afterElementIndex`, where `afterElementIndex`
 * is a first value-initialized element in a value-initialized range in
 * `initList`. If there are no remaining explicitly initialized elements in
 * `initList`, the result is the total number of elements in the array being
 * initialized.
 */
private int getEndOfValueInitializedRange(
  ArrayOrVectorAggregateLiteral initList, int afterElementIndex
) {
  result = getNextExplicitlyInitializedElementAfter(initList, afterElementIndex)
  or
  isFirstValueInitializedElementInRange(initList, afterElementIndex) and
  not exists(getNextExplicitlyInitializedElementAfter(initList, afterElementIndex)) and
  result = initList.getArraySize()
}

/**
 * Gets the index of the first explicitly initialized element in `initList`
 * whose index is greater than `afterElementIndex`, where `afterElementIndex`
 * is a first value-initialized element in a value-initialized range in
 * `initList`.
 */
private int getNextExplicitlyInitializedElementAfter(
  ArrayOrVectorAggregateLiteral initList, int afterElementIndex
) {
  isFirstValueInitializedElementInRange(initList, afterElementIndex) and
  result = min(int i | exists(initList.getElementExpr(i)) and i > afterElementIndex)
}

/**
 * Holds if element `elementIndex` is the first value-initialized element in a
 * range of one or more consecutive value-initialized elements in `initList`.
 */
private predicate isFirstValueInitializedElementInRange(
  ArrayOrVectorAggregateLiteral initList, int elementIndex
) {
  initList.isValueInitialized(elementIndex) and
  (
    elementIndex = 0 or
    exists(initList.getElementExpr(elementIndex - 1))
  )
}

/**
 * Represents an AST node for which IR needs to be generated.
 *
 * In most cases, there is a single `TranslatedElement` for each AST node.
 * However, when a single AST node performs two separable operations (e.g.
 * a `VariableAccess` that is also a load), there may be multiple
 * `TranslatedElement` nodes for a single AST node.
 */
abstract class TranslatedElement extends TTranslatedElement {
  abstract string toString();

  /**
   * Gets the AST node being translated.
   */
  abstract Locatable getAST();

  /**
   * Get the first instruction to be executed in the evaluation of this element.
   */
  abstract Instruction getFirstInstruction();

  /**
   * Get the immediate child elements of this element.
   */
  final TranslatedElement getAChild() { result = getChild(_) }

  /**
   * Gets the immediate child element of this element. The `id` is unique
   * among all children of this element, but the values are not necessarily
   * consecutive.
   */
  abstract TranslatedElement getChild(int id);

  /**
   * Gets the an identifier string for the element. This string is unique within
   * the scope of the element's function.
   */
  final string getId() { result = getUniqueId().toString() }

  private TranslatedElement getChildByRank(int rankIndex) {
    result =
      rank[rankIndex + 1](TranslatedElement child, int id | child = getChild(id) | child order by id)
  }

  language[monotonicAggregates]
  private int getDescendantCount() {
    result =
      1 + sum(TranslatedElement child | child = getChildByRank(_) | child.getDescendantCount())
  }

  private int getUniqueId() {
    if not exists(getParent())
    then result = 0
    else
      exists(TranslatedElement parent |
        parent = getParent() and
        if this = parent.getChildByRank(0)
        then result = 1 + parent.getUniqueId()
        else
          exists(int childIndex, TranslatedElement previousChild |
            this = parent.getChildByRank(childIndex) and
            previousChild = parent.getChildByRank(childIndex - 1) and
            result = previousChild.getUniqueId() + previousChild.getDescendantCount()
          )
      )
  }

  /**
   * Holds if this element generates an instruction with opcode `opcode` and
   * result type `resultType`. `tag` must be unique for each instruction
   * generated from the same AST node (not just from the same
   * `TranslatedElement`).
   * If the instruction does not return a result, `resultType` should be
   * `VoidType`.
   */
  abstract predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType);

  /**
   * Gets the `Function` that contains this element.
   */
  abstract Function getFunction();

  /**
   * Gets the successor instruction of the instruction that was generated by
   * this element for tag `tag`. The successor edge kind is specified by `kind`.
   */
  abstract Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind);

  /**
   * Gets the successor instruction to which control should flow after the
   * child element specified by `child` has finished execution.
   */
  abstract Instruction getChildSuccessor(TranslatedElement child);

  /**
   * Gets the instruction to which control should flow if an exception is thrown
   * within this element. This will generally return first `catch` block of the
   * nearest enclosing `try`, or the `Unwind` instruction for the function if
   * there is no enclosing `try`.
   */
  Instruction getExceptionSuccessorInstruction() {
    result = getParent().getExceptionSuccessorInstruction()
  }

  /**
   * Gets the primary instruction for the side effect instruction that was
   * generated by this element for tag `tag`.
   */
  Instruction getPrimaryInstructionForSideEffect(InstructionTag tag) { none() }

  /**
   * Holds if this element generates a temporary variable with type `type`.
   * `tag` must be unique for each variable generated from the same AST node
   * (not just from the same `TranslatedElement`).
   */
  predicate hasTempVariable(TempVariableTag tag, CppType type) { none() }

  /**
   * If the instruction specified by `tag` is a `FunctionInstruction`, gets the
   * `Function` for that instruction.
   */
  Function getInstructionFunction(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` is a `VariableInstruction`, gets the
   * `IRVariable` for that instruction.
   */
  IRVariable getInstructionVariable(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` is a `FieldInstruction`, gets the
   * `Field` for that instruction.
   */
  Field getInstructionField(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` is a `ConstantValueInstruction`, gets
   * the constant value for that instruction.
   */
  string getInstructionConstantValue(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` is an `IndexedInstruction`, gets the
   * index for that instruction.
   */
  int getInstructionIndex(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` is a `PointerArithmeticInstruction`,
   * gets the size of the type pointed to by the pointer.
   */
  int getInstructionElementSize(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` has a result of type `UnknownType`,
   * gets the size of the result in bytes. If the result does not have a knonwn
   * constant size, this predicate does not hold.
   */
  int getInstructionResultSize(InstructionTag tag) { none() }

  predicate needsUnknownOpaqueType(int byteSize) { none() }

  /**
   * If the instruction specified by `tag` is a `StringConstantInstruction`,
   * gets the `StringLiteral` for that instruction.
   */
  StringLiteral getInstructionStringLiteral(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` is a `BuiltInInstruction`, gets the built-in operation.
   */
  BuiltInOperation getInstructionBuiltInOperation(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` is a `CatchByTypeInstruction`,
   * gets the type of the exception to be caught.
   */
  CppType getInstructionExceptionType(InstructionTag tag) { none() }

  /**
   * If the instruction specified by `tag` is an `InheritanceConversionInstruction`,
   * gets the inheritance relationship for that instruction.
   */
  predicate getInstructionInheritance(InstructionTag tag, Class baseClass, Class derivedClass) {
    none()
  }

  /**
   * Gets the instruction whose result is consumed as an operand of the
   * instruction specified by `tag`, with the operand specified by `operandTag`.
   */
  Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) { none() }

  /**
   * Gets the type of the memory operand specified by `operandTag` on the the instruction specified by `tag`.
   */
  CppType getInstructionOperandType(InstructionTag tag, TypedOperandTag operandTag) { none() }

  /**
   * Gets the size of the memory operand specified by `operandTag` on the the instruction specified by `tag`.
   * Only holds for operands whose type is `UnknownType`.
   */
  int getInstructionOperandSize(InstructionTag tag, SideEffectOperandTag operandTag) { none() }

  /**
   * Gets the instruction generated by this element with tag `tag`.
   */
  final Instruction getInstruction(InstructionTag tag) {
    getInstructionTranslatedElement(result) = this and
    getInstructionTag(result) = tag
  }

  /**
   * Gets the temporary variable generated by this element with tag `tag`.
   */
  final IRTempVariable getTempVariable(TempVariableTag tag) {
    exists(Locatable ast |
      result.getAST() = ast and
      result.getTag() = tag and
      hasTempVariableAndAST(tag, ast)
    )
  }

  pragma[noinline]
  private predicate hasTempVariableAndAST(TempVariableTag tag, Locatable ast) {
    hasTempVariable(tag, _) and
    ast = getAST()
  }

  /**
   * Gets the parent element of this element.
   */
  final TranslatedElement getParent() { result.getAChild() = this }
}
