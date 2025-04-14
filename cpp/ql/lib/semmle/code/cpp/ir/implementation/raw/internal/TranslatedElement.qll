private import cpp
import semmle.code.cpp.ir.implementation.raw.IR
private import semmle.code.cpp.internal.ExtractorVersion
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
private import SideEffects

/**
 * Gets the "real" parent of `expr`. This predicate treats conversions as if
 * they were explicit nodes in the expression tree, rather than as implicit
 * nodes as in the regular AST representation.
 */
Element getRealParent(Expr expr) {
  result = expr.getParentWithConversions()
  or
  result.(Destructor).getADestruction() = expr
  or
  result.(Expr).getAnImplicitDestructorCall() = expr
  or
  result.(Stmt).getAnImplicitDestructorCall() = expr
}

IRUserVariable getIRUserVariable(Declaration decl, Variable var) {
  result.getVariable() = var and
  result.getEnclosingFunction() = decl
}

IRTempVariable getIRTempVariable(Locatable ast, TempVariableTag tag) {
  result.getAst() = ast and
  result.getTag() = tag
}

/** Gets an operand of `op`. */
private Expr getAnOperand(Operation op) { result = op.getAnOperand() }

/**
 * Gets the number of nested operands of `op`. For example,
 * `getNumberOfNestedBinaryOperands((1 + 2) + 3))` is `3`.
 */
private int getNumberOfNestedBinaryOperands(Operation op) { result = count(getAnOperand*(op)) }

/**
 * Holds if `op` should not be translated to a `ConstantInstruction` as part of
 * IR generation, even if the value of `op` is constant.
 */
private predicate ignoreConstantValue(Operation op) {
  op instanceof BitwiseAndExpr
  or
  op instanceof BitwiseOrExpr
  or
  op instanceof BitwiseXorExpr
}

/**
 * Holds if `expr` is a constant of a type that can be replaced directly with
 * its value in the IR. This does not include address constants as we have no
 * means to express those as QL values.
 */
predicate isIRConstant(Expr expr) {
  exists(expr.getValue()) and
  // We avoid constant folding certain operations since it's often useful to
  // mark one of those as a source in dataflow, and if the operation is
  // constant folded it's not possible to mark its operands as a source (or
  // sink).
  // But to avoid creating an outrageous amount of IR from very large
  // constant expressions we fall back to constant folding if the operation
  // has more than 50 operands (i.e., 1 + 2 + 3 + 4 + ... + 50)
  if ignoreConstantValue(expr) then getNumberOfNestedBinaryOperands(expr) > 50 else any()
}

// Pulled out for performance. See
// https://github.com/github/codeql-coreql-team/issues/1044.
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
  exists(DeleteOrDeleteArrayExpr deleteExpr |
    // Ignore the deallocator call, because we always synthesize it.
    deleteExpr.getDeallocatorCall() = expr
  )
  or
  // Do not translate input/output variables in GNU asm statements
  //  getRealParent(expr) instanceof AsmStmt
  //  or
  ignoreExprAndDescendants(getRealParent(expr)) // recursive case
  or
  // va_start doesn't evaluate its argument, so we don't need to translate it.
  exists(BuiltInVarArgsStart vaStartExpr |
    vaStartExpr.getLastNamedParameter().getFullyConverted() = expr
  )
  or
  // The children of C11 _Generic expressions are just surface syntax.
  exists(C11GenericExpr generic | generic.getAChild() = expr)
  or
  // Do not translate implicit destructor calls for unnamed temporary variables that are
  // conditionally constructed (until we have a mechanism for calling these only when the
  // temporary's constructor was run)
  isConditionalTemporaryDestructorCall(expr)
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
  not translateFunction(getEnclosingFunction(expr)) and
  not Raw::varHasIRFunc(getEnclosingVariable(expr))
}

/**
 * Holds if `expr` should be ignored for the purposes of IR generation.
 */
private predicate ignoreExpr(Expr expr) {
  ignoreExprOnly(expr) or
  ignoreExprAndDescendants(expr)
}

/**
 * Holds if the side effects of `expr` should be ignored for the purposes of IR generation.
 *
 * In cases involving `constexpr`, a call can wind up as a constant expression. `ignoreExpr()` will
 * not hold for such a call, since we do need to translate the call (as a constant), but we need to
 * ignore all of the side effects of that call, since we will not actually be generating a `Call`
 * instruction.
 */
private predicate ignoreSideEffects(Expr expr) {
  ignoreExpr(expr)
  or
  isIRConstant(expr)
}

/**
 * Holds if `func` contains an AST that cannot be translated into IR. This is mostly used to work
 * around extractor bugs. Once the relevant extractor bugs are fixed, this predicate can be removed.
 */
private predicate isInvalidFunction(Function func) {
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
  or
  count(func.getEntryPoint().getLocation()) > 1
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
  expr instanceof ParenthesisExpr and
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
  exists(ConstexprIfStmt ifStmt | ifStmt.getCondition().getFullyConverted() = expr)
  or
  exists(ConditionalExpr condExpr |
    // The two-operand form of `ConditionalExpr` treats its condition as a value, since it needs to
    // be reused as a value if the condition is true.
    condExpr.getCondition().getFullyConverted() = expr and not condExpr.isTwoOperand()
  )
  or
  exists(ParenthesisExpr paren |
    paren.getExpr() = expr and
    usedAsCondition(paren)
  )
}

private predicate hasThrowingChild(Expr e) {
  e = any(ThrowExpr throw).getFullyConverted()
  or
  exists(Expr child |
    e = getRealParent(child) and
    hasThrowingChild(child)
  )
}

private predicate isInConditionalEvaluation(Expr e) {
  exists(ConditionalExpr cond |
    e = cond.getThen().getFullyConverted() and not cond.isTwoOperand()
    or
    e = cond.getElse().getFullyConverted()
    or
    // If one of the operands throws then the temporaries constructed in either
    // branch will also be attached to the ternary expression. We suppress
    // those destructor calls as well.
    hasThrowingChild([cond.getThen(), cond.getElse()]) and
    e = cond.getFullyConverted()
  )
  or
  e = any(LogicalAndExpr lae).getRightOperand().getFullyConverted()
  or
  e = any(LogicalOrExpr loe).getRightOperand().getFullyConverted()
  or
  isInConditionalEvaluation(getRealParent(e))
}

private predicate isConditionalTemporaryDestructorCall(DestructorCall dc) {
  exists(TemporaryObjectExpr temp |
    temp = dc.getQualifier().(ReuseExpr).getReusedExpr() and
    isInConditionalEvaluation(temp)
  )
}

/**
 * Holds if `conv` is an `InheritanceConversion` that requires a `TranslatedLoad`, despite not being
 * marked as having an lvalue-to-rvalue conversion.
 *
 * This is necessary for an `InheritanceConversion` that is originally modeled as a
 * prvalue-to-prvalue conversion, since we transform it into a glvalue-to-glvalue conversion. If it
 * is actually consumed as a prvalue, such as on the right hand side of an assignment, we need to
 * load the resulting glvalue.
 */
private predicate isInheritanceConversionWithImplicitLoad(InheritanceConversion conv) {
  // Must have originally been a prvalue-to-prvalue conversion.
  isClassPRValue(conv.getExpr()) and
  not conv.hasLValueToRValueConversion() and
  // Exclude that case where this will be consumed as a glvalue, such as when used as the qualifier
  // of a field access.
  not isPRValueConversionOnGLValue(conv)
}

/**
 * Holds if `expr` is the result of a field access whose qualifier was a prvalue and whose result is
 * a prvalue. These accesses are not marked as having loads, but we do need a load in the IR.
 */
private predicate isPRValueFieldAccessWithImplicitLoad(Expr expr) {
  expr instanceof ValueFieldAccess and
  expr.isPRValueCategory() and
  // No need to do a load if we're replacing the result with a constant anyway.
  not isIRConstant(expr) and
  // Model an array prvalue as the address of the array, just like an array glvalue.
  not expr.getUnspecifiedType() instanceof ArrayType
}

/**
 * Holds if `expr` is a prvalue of class type.
 *
 * This same test is used in several places.
 */
pragma[inline]
private predicate isClassPRValue(Expr expr) {
  expr.isPRValueCategory() and
  expr.getUnspecifiedType() instanceof Class
}

/**
 * Holds if `expr` is consumed as a glvalue by its parent. If `expr` is actually a prvalue, it will
 * have any lvalue-to-rvalue conversion ignored. If it does not have an lvalue-to-rvalue conversion,
 * it will be materialized into a temporary object.
 */
private predicate consumedAsGLValue(Expr expr) {
  isClassPRValue(expr) and
  (
    // Qualifier of a field access.
    expr = any(FieldAccess a).getQualifier().getFullyConverted()
    or
    // Qualifier of a member function call.
    expr = any(Call c).getQualifier().getFullyConverted()
    or
    // The operand of an inheritance conversion.
    expr = any(InheritanceConversion c).getExpr()
  )
}

/**
 * Holds if `expr` is a conversion that is originally a prvalue-to-prvalue conversion, but which is
 * applied to a prvalue that will actually be consumed as a glvalue.
 */
predicate isPRValueConversionOnGLValue(Conversion conv) {
  exists(Expr consumed |
    consumedAsGLValue(consumed) and
    isClassPRValue(conv.getExpr()) and
    (
      // Example: The conversion of `std::string` to `const std::string` when evaluating
      // `std::string("foo").c_str()`.
      conv instanceof PrvalueAdjustmentConversion
      or
      // Parentheses are transparent.
      conv instanceof ParenthesisExpr
      or
      // Example: The base class conversion in `f().m()`, when `m` is member function of a base
      // class of the return type of `f()`.
      conv instanceof InheritanceConversion
    ) and
    (
      // Base case: The conversion is consumed directly.
      conv = consumed
      or
      // Recursive case: The conversion is the operand of another prvalue conversion.
      isPRValueConversionOnGLValue(conv.getConversion())
    )
  )
}

/**
 * Holds if `expr` is a prvalue of class type that is used in a context that requires a glvalue.
 *
 * Any conversions between `expr` and the ancestor that consumes the glvalue will also be treated
 * as glvalues, but are not part of this relation.
 *
 * For example:
 * ```c++
 * std::string("s").c_str();
 * ```
 * The object for the qualifier is a prvalue(load) of type `std::string`, but the actual
 * fully-converted qualifier of the call to `c_str()` is a prvalue adjustment conversion that
 * converts the type to `const std::string` to match the type of the `this` pointer of the
 * member function. In this case, `mustTransformToGLValue()` will hold for the temporary
 * `std::string` object, but not the prvalue adjustment on top of it.
 * `isPRValueConversionOnGLValue()` would hold for the prvalue adjustment.
 */
private predicate mustTransformToGLValue(Expr expr) {
  not isPRValueConversionOnGLValue(expr) and
  (
    // The expression is the fully converted qualifier, with no prvalue adjustments on top.
    consumedAsGLValue(expr)
    or
    // The expression has conversions on top, but they are all prvalue adjustments.
    isPRValueConversionOnGLValue(expr.getConversion())
  )
}

/**
 * Holds if `expr` has an lvalue-to-rvalue conversion that should be ignored
 * when generating IR. This occurs for conversion from an lvalue of function type
 * to an rvalue of function pointer type. The conversion is represented in the
 * AST as an lvalue-to-rvalue conversion, but the IR represents both a function
 * lvalue and a function pointer prvalue the same.
 */
predicate ignoreLoad(Expr expr) {
  expr.hasLValueToRValueConversion() and
  (
    expr instanceof ThisExpr
    or
    expr instanceof FunctionAccess
    or
    // The load is duplicated from the operand.
    isExtractorFrontendVersion65OrHigher() and expr instanceof ParenthesisExpr
    or
    // The load is duplicated from the right operand.
    isExtractorFrontendVersion65OrHigher() and expr instanceof CommaExpr
    or
    // The load is duplicated from the chosen expression.
    expr instanceof C11GenericExpr
    or
    expr.(PointerDereferenceExpr).getOperand().getFullyConverted().getType().getUnspecifiedType()
      instanceof FunctionPointerType
    or
    expr.(ReferenceDereferenceExpr).getExpr().getType().getUnspecifiedType() instanceof
      FunctionReferenceType
    or
    // The extractor represents the qualifier of a field access or member function call as a load of
    // the temporary object if the original qualifier was a prvalue. For IR purposes, we always want
    // to use the address of the temporary object as the qualifier of a field access or the `this`
    // argument to a member function call.
    mustTransformToGLValue(expr)
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
  or
  // For arguments that are passed by value but require a constructor call, the extractor emits a
  // `TemporaryObjectExpr` as the argument, and marks it as a glvalue. This is roughly how a code-
  // generating compiler would implement this, passing the address of the temporary so that the
  // callee is using the exact same memory location allocated by the caller. We don't fully model
  // this yet, though, so we'll synthesize a load so that we appear to be passing the temporary
  // object via a bitwise copy.
  exists(Call call |
    expr = call.getAnArgument().getFullyConverted().(TemporaryObjectExpr) and
    expr.isGLValueCategory()
  )
}

/**
 * Holds if `expr` should have a `TranslatedLoad` on it.
 */
predicate hasTranslatedLoad(Expr expr) {
  (
    expr.hasLValueToRValueConversion()
    or
    needsLoadForParentExpr(expr)
    or
    isPRValueFieldAccessWithImplicitLoad(expr)
    or
    isInheritanceConversionWithImplicitLoad(expr)
  ) and
  not ignoreExpr(expr) and
  not isNativeCondition(expr) and
  not isFlexibleCondition(expr) and
  not ignoreLoad(expr) and
  // don't insert a load since we'll just substitute the constant value.
  not isIRConstant(expr)
}

/**
 * Holds if `expr` should have a `TranslatedSyntheticTemporaryObject` on it.
 */
predicate hasTranslatedSyntheticTemporaryObject(Expr expr) {
  not ignoreExpr(expr) and
  mustTransformToGLValue(expr) and
  // If it's a load, we'll just ignore the load in `ignoreLoad()`.
  not expr.hasLValueToRValueConversion()
}

class StaticInitializedStaticLocalVariable extends StaticLocalVariable {
  StaticInitializedStaticLocalVariable() {
    this.hasInitializer() and
    not this.hasDynamicInitialization()
  }
}

class RuntimeInitializedStaticLocalVariable extends StaticLocalVariable {
  RuntimeInitializedStaticLocalVariable() { this.hasDynamicInitialization() }
}

/**
 * Holds if the specified `DeclarationEntry` needs an IR translation. An IR translation is only
 * necessary for automatic local variables, or for static local variables with dynamic
 * initialization.
 */
private predicate translateDeclarationEntry(IRDeclarationEntry entry) {
  exists(DeclStmt declStmt, LocalVariable var |
    translateStmt(declStmt) and
    declStmt = entry.getStmt() and
    // Only declarations of local variables need to be translated to IR.
    var = entry.getDeclaration() and
    (
      not var.isStatic()
      or
      // Ignore static variables unless they have a dynamic initializer.
      var instanceof RuntimeInitializedStaticLocalVariable
    )
  )
}

private module IRDeclarationEntries {
  private newtype TIRDeclarationEntry =
    TPresentDeclarationEntry(DeclarationEntry entry) or
    TMissingDeclarationEntry(DeclStmt stmt, Declaration d, int index) {
      not exists(stmt.getDeclarationEntry(index)) and
      stmt.getDeclaration(index) = d
    }

  /**
   * An entity that represents a declaration entry in the database.
   *
   * This class exists to work around the fact that `DeclStmt`s in some cases
   * do not have `DeclarationEntry`s in older databases.
   *
   * So instead, the IR works with `IRDeclarationEntry`s that synthesize missing
   * `DeclarationEntry`s when there is no result for `DeclStmt::getDeclarationEntry`.
   */
  abstract class IRDeclarationEntry extends TIRDeclarationEntry {
    /** Gets a string representation of this `IRDeclarationEntry`. */
    abstract string toString();

    /** Gets the `DeclStmt` that this `IRDeclarationEntry` belongs to. */
    abstract DeclStmt getStmt();

    /** Gets the `Declaration` declared by this `IRDeclarationEntry`. */
    abstract Declaration getDeclaration();

    /** Gets the AST represented by this `IRDeclarationEntry`. */
    abstract Locatable getAst();

    /**
     * Holds if this `IRDeclarationEntry` is the `index`'th entry
     * declared by the enclosing `DeclStmt`.
     */
    abstract predicate hasIndex(int index);
  }

  /** A `IRDeclarationEntry` for an existing `DeclarationEntry`. */
  private class PresentDeclarationEntry extends IRDeclarationEntry, TPresentDeclarationEntry {
    DeclarationEntry entry;

    PresentDeclarationEntry() { this = TPresentDeclarationEntry(entry) }

    override string toString() { result = entry.toString() }

    override DeclStmt getStmt() { result.getADeclarationEntry() = entry }

    override Declaration getDeclaration() { result = entry.getDeclaration() }

    override Locatable getAst() { result = entry }

    override predicate hasIndex(int index) { this.getStmt().getDeclarationEntry(index) = entry }
  }

  /**
   * A synthesized `DeclarationEntry` that is created when a `DeclStmt` is missing a
   * result for `DeclStmt::getDeclarationEntry`
   */
  private class MissingDeclarationEntry extends IRDeclarationEntry, TMissingDeclarationEntry {
    DeclStmt stmt;
    Declaration d;
    int index;

    MissingDeclarationEntry() { this = TMissingDeclarationEntry(stmt, d, index) }

    override string toString() { result = "missing declaration of " + d.getName() }

    override DeclStmt getStmt() { result = stmt }

    override Declaration getDeclaration() { result = d }

    override Locatable getAst() { result = stmt }

    override predicate hasIndex(int idx) { idx = index }
  }

  /** A `IRDeclarationEntry` that represents an entry for a `Variable`. */
  class IRVariableDeclarationEntry instanceof IRDeclarationEntry {
    Variable v;

    IRVariableDeclarationEntry() { super.getDeclaration() = v }

    Variable getDeclaration() { result = v }

    string toString() { result = super.toString() }

    Locatable getAst() { result = super.getAst() }

    DeclStmt getStmt() { result = super.getStmt() }
  }
}

import IRDeclarationEntries

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
  // A temporary object that we had to synthesize ourselves, so that we could do a field access or
  // method call on a prvalue.
  TTranslatedSyntheticTemporaryObject(Expr expr) { hasTranslatedSyntheticTemporaryObject(expr) } or
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
      exists(Initializer init | init.getExpr().getFullyConverted() = expr)
      or
      exists(ClassAggregateLiteral initList | initList.getAFieldExpr(_).getFullyConverted() = expr)
      or
      exists(ArrayOrVectorAggregateLiteral initList |
        initList.getAnElementExpr(_).getFullyConverted() = expr
      )
      or
      exists(ReturnStmt returnStmt |
        returnStmt.getExpr().getFullyConverted() = expr and
        hasReturnValue(returnStmt.getEnclosingFunction())
      )
      or
      exists(ConstructorFieldInit fieldInit | fieldInit.getExpr().getFullyConverted() = expr)
      or
      exists(NewExpr newExpr | newExpr.getInitializer().getFullyConverted() = expr)
      or
      exists(ThrowExpr throw | throw.getExpr().getFullyConverted() = expr)
      or
      exists(TemporaryObjectExpr temp | temp.getExpr() = expr)
      or
      exists(LambdaExpression lambda | lambda.getInitializer().getFullyConverted() = expr)
    )
  } or
  // The initialization of a field via a member of an initializer list.
  TTranslatedExplicitFieldInitialization(Expr ast, Field field, Expr expr, int position) {
    exists(ClassAggregateLiteral initList |
      not ignoreExpr(initList) and
      ast = initList and
      expr = initList.getFieldExpr(field, position).getFullyConverted()
    )
    or
    exists(ConstructorFieldInit init |
      not ignoreExpr(init) and
      ast = init and
      field = init.getTarget() and
      expr = init.getExpr().getFullyConverted() and
      position = -1
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
  TTranslatedExplicitElementInitialization(
    ArrayOrVectorAggregateLiteral initList, int elementIndex, int position
  ) {
    not ignoreExpr(initList) and
    exists(initList.getElementExpr(elementIndex, position))
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
  // Workaround for a case where no base constructor is generated but a targetless base
  // constructor call is present.
  TTranslatedConstructorBareInit(ConstructorInit init) {
    not ignoreExpr(init) and
    not init instanceof ConstructorBaseInit and
    not init instanceof ConstructorFieldInit
  } or
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
  // The `__except` block of a `__try __except` statement
  TTranslatedMicrosoftTryExceptHandler(MicrosoftTryExceptStmt stmt) or
  // The `__finally` block of a `__try __finally` statement
  TTranslatedMicrosoftTryFinallyHandler(MicrosoftTryFinallyStmt stmt) or
  // A function
  TTranslatedFunction(Function func) { translateFunction(func) } or
  // A constructor init list
  TTranslatedConstructorInitList(Function func) { translateFunction(func) } or
  // A destructor destruction list
  TTranslatedDestructorDestructionList(Function func) { translateFunction(func) } or
  TTranslatedThisParameter(Function func) {
    translateFunction(func) and func.isMember() and not func.isStatic()
  } or
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
  TTranslatedThisReadEffect(Function func) {
    translateFunction(func) and func.isMember() and not func.isStatic()
  } or
  // The read side effects in a function's return block
  TTranslatedParameterReadEffect(Parameter param) {
    translateFunction(param.getFunction()) and
    exists(Type t | t = param.getUnspecifiedType() |
      t instanceof ArrayType or
      t instanceof PointerType or
      t instanceof ReferenceType
    )
  } or
  // A local declaration
  TTranslatedDeclarationEntry(IRDeclarationEntry entry) { translateDeclarationEntry(entry) } or
  // The dynamic initialization of a static local variable. This is a separate object from the
  // declaration entry.
  TTranslatedStaticLocalVariableInitialization(IRDeclarationEntry entry) {
    translateDeclarationEntry(entry) and
    entry.getDeclaration() instanceof StaticLocalVariable
  } or
  // An allocator call in a `new` or `new[]` expression
  TTranslatedAllocatorCall(NewOrNewArrayExpr newExpr) { not ignoreExpr(newExpr) } or
  // An allocation size for a `new` or `new[]` expression
  TTranslatedAllocationSize(NewOrNewArrayExpr newExpr) { not ignoreExpr(newExpr) } or
  // The declaration/initialization part of a `ConditionDeclExpr`
  TTranslatedConditionDecl(ConditionDeclExpr expr) { not ignoreExpr(expr) } or
  // The side effects of a `Call`
  TTranslatedCallSideEffects(CallOrAllocationExpr expr) {
    not ignoreExpr(expr) and
    not ignoreSideEffects(expr)
  } or
  // The non-argument-specific side effect of a `Call`
  TTranslatedCallSideEffect(Expr expr, SideEffectOpcode opcode) {
    not ignoreExpr(expr) and
    not ignoreSideEffects(expr) and
    opcode = getCallSideEffectOpcode(expr)
  } or
  // The set of destructors to invoke after a `throw`. These need to be special
  // cased because the edge kind following a throw is an `ExceptionEdge`, and
  // we need to make sure that the edge kind is still an `ExceptionEdge` after
  // all the destructors have run.
  TTranslatedDestructorsAfterThrow(ThrowExpr throw) {
    exists(DestructorCall dc |
      dc = throw.getAnImplicitDestructorCall() and
      not ignoreExpr(dc)
    )
  } or
  // The set of destructors to invoke after a handler for a `try` statement. These
  // need to be special cased because the destructors need to run following an
  // `ExceptionEdge`, but not following a `GotoEdge` edge.
  TTranslatedDestructorsAfterHandler(Handler handler) {
    exists(handler.getAnImplicitDestructorCall())
  } or
  // A precise side effect of an argument to a `Call`
  TTranslatedArgumentExprSideEffect(Call call, Expr expr, int n, SideEffectOpcode opcode) {
    not ignoreExpr(expr) and
    not ignoreSideEffects(call) and
    (
      n >= 0 and expr = call.getArgument(n).getFullyConverted()
      or
      n = -1 and expr = call.getQualifier().getFullyConverted()
    ) and
    opcode = getASideEffectOpcode(call, n)
  } or
  // Constructor calls lack a qualifier (`this`) expression, so we need to handle the side effects
  // on `*this` without an `Expr`.
  TTranslatedStructorQualifierSideEffect(Call call, SideEffectOpcode opcode) {
    not ignoreExpr(call) and
    not ignoreSideEffects(call) and
    call instanceof ConstructorCall and
    opcode = getASideEffectOpcode(call, -1)
  } or
  // The side effect that initializes newly-allocated memory.
  TTranslatedAllocationSideEffect(AllocationExpr expr) { not ignoreSideEffects(expr) } or
  TTranslatedStaticStorageDurationVarInit(Variable var) { Raw::varHasIRFunc(var) }

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
  result = min(int i | exists(initList.getAnElementExpr(i)) and i > afterElementIndex)
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
    exists(initList.getAnElementExpr(elementIndex - 1))
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
  abstract Locatable getAst();

  /** Gets the location of this element. */
  Location getLocation() { result = this.getAst().getLocation() }

  /**
   * Get the first instruction to be executed in the evaluation of this
   * element when the edge kind is `kind`.
   */
  abstract Instruction getFirstInstruction(EdgeKind kind);

  /**
   * Get the immediate child elements of this element.
   */
  final TranslatedElement getAChild() { result = this.getChild(_) }

  /**
   * Gets the immediate child element of this element. The `id` is unique
   * among all children of this element, but the values are not necessarily
   * consecutive.
   */
  abstract TranslatedElement getChild(int id);

  /**
   * Gets the an identifier string for the element. This id is unique within
   * the scope of the element's function.
   */
  final int getId() { result = this.getUniqueId() }

  private TranslatedElement getChildByRank(int rankIndex) {
    result =
      rank[rankIndex + 1](TranslatedElement child, int id |
        child = this.getChild(id)
      |
        child order by id
      )
  }

  language[monotonicAggregates]
  private int getDescendantCount() {
    result =
      1 + sum(TranslatedElement child | child = this.getChildByRank(_) | child.getDescendantCount())
  }

  /**
   * Holds if this element has implicit destructor calls that should follow it.
   */
  predicate hasAnImplicitDestructorCall() { none() }

  /**
   * Gets the child index of the first destructor call that should be executed after this `TranslatedElement`
   */
  int getFirstDestructorCallIndex() { none() }

  /**
   * Holds if this `TranslatedElement` includes any destructor calls that must be performed after
   * it in its `getChildSuccessorInternal`, `getInstructionSuccessorInternal`, and
   * `getALastInstructionInternal` relations, rather than needing them inserted.
   */
  predicate handlesDestructorsExplicitly() { none() }

  private int getUniqueId() {
    if not exists(this.getParent())
    then result = 0
    else
      exists(TranslatedElement parent |
        parent = this.getParent() and
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
  abstract Declaration getFunction();

  /**
   * Gets the successor instruction of the instruction that was generated by
   * this element for tag `tag`. The successor edge kind is specified by `kind`.
   * This predicate does not usually include destructors, which are inserted as
   * part of `getInstructionSuccessor` unless `handlesDestructorsExplicitly`
   * holds.
   */
  abstract Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind);

  /**
   * Gets the successor instruction of the instruction that was generated by
   * this element for tag `tag`. The successor edge kind is specified by `kind`.
   */
  final Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    if
      this.hasAnImplicitDestructorCall() and
      this.getInstruction(tag) = this.getALastInstructionInternal() and
      not this.handlesDestructorsExplicitly()
    then
      result = this.getChild(this.getFirstDestructorCallIndex()).getFirstInstruction(kind) and
      kind instanceof GotoEdge
    else result = this.getInstructionSuccessorInternal(tag, kind)
  }

  /**
   * Gets an instruction within this `TranslatedElement` (including its transitive children) which
   * will be followed by an instruction outside the `TranslatedElement`.
   */
  final Instruction getALastInstruction() {
    if this.hasAnImplicitDestructorCall() and not this.handlesDestructorsExplicitly()
    then result = this.getChild(max(int n | exists(this.getChild(n)))).getALastInstruction() // last destructor
    else result = this.getALastInstructionInternal()
  }

  /**
   * Gets an instruction within this `TranslatedElement` (including its transitive children) which
   * will be followed by an instruction outside the `TranslatedElement`.
   * This predicate does not usually include destructors, which are inserted as
   * part of `getALastInstruction` unless `handlesDestructorsExplicitly` holds.
   */
  abstract Instruction getALastInstructionInternal();

  TranslatedElement getLastChild() { none() }

  /**
   * Gets the successor instruction to which control should flow after the
   * child element specified by `child` has finished execution. The successor
   * edge kind is specified by `kind`.
   * This predicate does not usually include destructors, which are inserted as
   * part of `getChildSuccessor` unless `handlesDestructorsExplicitly` holds.
   */
  Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) { none() }

  /**
   * Gets the successor instruction to which control should flow after the
   * child element specified by `child` has finished execution. The successor
   * edge kind is specified by `kind`.
   */
  final Instruction getChildSuccessor(TranslatedElement child, EdgeKind kind) {
    (
      if
        // this is the last child and we need to handle destructors for it
        this.hasAnImplicitDestructorCall() and
        not this.handlesDestructorsExplicitly() and
        child = this.getLastChild()
      then result = this.getChild(this.getFirstDestructorCallIndex()).getFirstInstruction(kind)
      else result = this.getChildSuccessorInternal(child, kind)
    )
    or
    not this.handlesDestructorsExplicitly() and
    exists(int id |
      id >= this.getFirstDestructorCallIndex() and
      child = this.getChild(id) and
      if id = max(int n | exists(this.getChild(n)))
      then result = this.getParent().getChildSuccessor(this, kind)
      else result = this.getChild(id + 1).getFirstInstruction(kind)
    )
  }

  /**
   * Gets the instruction to which control should flow if an exception is thrown
   * within this element. This will generally return first `catch` block of the
   * nearest enclosing `try`, or the `Unwind` instruction for the function if
   * there is no enclosing `try`. The successor edge kind is specified by `kind`.
   */
  Instruction getExceptionSuccessorInstruction(EdgeKind kind) {
    result = this.getParent().getExceptionSuccessorInstruction(kind)
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
   * Holds if the generated IR refers to an opaque type with size `byteSize`.
   */
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
  Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) { none() }

  /**
   * Gets the type of the memory operand specified by `operandTag` on the the instruction specified by `tag`.
   */
  CppType getInstructionMemoryOperandType(InstructionTag tag, TypedOperandTag operandTag) { none() }

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
      result.getAst() = ast and
      result.getTag() = tag and
      this.hasTempVariableAndAst(tag, ast)
    )
  }

  pragma[noinline]
  private predicate hasTempVariableAndAst(TempVariableTag tag, Locatable ast) {
    this.hasTempVariable(tag, _) and
    ast = this.getAst()
  }

  /**
   * Gets the parent element of this element.
   */
  final TranslatedElement getParent() { result.getAChild() = this }
}

/**
 * The IR translation of a root element, either a function or a global variable.
 */
abstract class TranslatedRootElement extends TranslatedElement {
  TranslatedRootElement() {
    this instanceof TTranslatedFunction
    or
    this instanceof TTranslatedStaticStorageDurationVarInit
  }
}
