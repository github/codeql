/**
 * Provides a local analysis for identifying where a variable address or value
 * may escape an _expression tree_, meaning that it is assigned to a variable,
 * passed to a function, or similar.
 */

/*
 * Maintainer note: this file is one of several files that are similar but not
 * identical. Many changes to this file will also apply to the others:
 * - AddressConstantExpression.qll
 * - AddressFlow.qll
 * - EscapesTree.qll
 */

private import cpp

/**
 * Holds if `f` is an instantiation of the `std::move` or `std::forward`
 * template functions, these functions are essentially casts, so we treat them
 * as such.
 */
private predicate stdIdentityFunction(Function f) { f.hasQualifiedName("std", ["move", "forward"]) }

/**
 * Holds if `f` is an instantiation of `std::addressof`, which effectively
 * converts a reference to a pointer.
 */
private predicate stdAddressOf(Function f) { f.hasQualifiedName("std", "addressof") }

private predicate lvalueToLvalueStepPure(Expr lvalueIn, Expr lvalueOut) {
  lvalueIn = lvalueOut.(DotFieldAccess).getQualifier().getFullyConverted()
  or
  lvalueIn.getConversion() = lvalueOut.(ParenthesisExpr)
  or
  // When an object is implicitly converted to a reference to one of its base
  // classes, it gets two `Conversion`s: there is first an implicit
  // `CStyleCast` to its base class followed by a `ReferenceToExpr` to a
  // reference to its base class. Whereas an explicit cast to the base class
  // would produce an rvalue, which would not be convertible to an lvalue
  // reference, this implicit cast instead produces an lvalue. The following
  // case ensures that we propagate the property of being an lvalue through
  // such casts.
  lvalueIn.getConversion() = lvalueOut and
  lvalueOut.(CStyleCast).isImplicit()
}

private predicate lvalueToLvalueStep(Expr lvalueIn, Expr lvalueOut) {
  lvalueToLvalueStepPure(lvalueIn, lvalueOut)
  or
  // C++ only
  lvalueIn = lvalueOut.(PrefixCrementOperation).getOperand().getFullyConverted()
  or
  // C++ only
  lvalueIn = lvalueOut.(Assignment).getLValue().getFullyConverted()
}

private predicate pointerToLvalueStep(Expr pointerIn, Expr lvalueOut) {
  pointerIn = lvalueOut.(ArrayExpr).getArrayBase().getFullyConverted()
  or
  pointerIn = lvalueOut.(PointerDereferenceExpr).getOperand().getFullyConverted()
  or
  pointerIn = lvalueOut.(PointerFieldAccess).getQualifier().getFullyConverted()
}

private predicate lvalueToPointerStep(Expr lvalueIn, Expr pointerOut) {
  lvalueIn.getConversion() = pointerOut.(ArrayToPointerConversion)
  or
  lvalueIn = pointerOut.(AddressOfExpr).getOperand().getFullyConverted()
}

private predicate pointerToPointerStep(Expr pointerIn, Expr pointerOut) {
  (
    pointerOut instanceof PointerAddExpr
    or
    pointerOut instanceof PointerSubExpr
  ) and
  pointerIn = pointerOut.getAChild().getFullyConverted() and
  pointerIn.getUnspecifiedType() instanceof PointerType
  or
  pointerIn = pointerOut.(UnaryPlusExpr).getOperand().getFullyConverted()
  or
  pointerIn.getConversion() = pointerOut.(Cast)
  or
  pointerIn.getConversion() = pointerOut.(ParenthesisExpr)
  or
  pointerIn.getConversion() = pointerOut.(TemporaryObjectExpr)
  or
  pointerIn = pointerOut.(ConditionalExpr).getThen().getFullyConverted()
  or
  pointerIn = pointerOut.(ConditionalExpr).getElse().getFullyConverted()
  or
  pointerIn = pointerOut.(CommaExpr).getRightOperand().getFullyConverted()
  or
  pointerIn = pointerOut.(StmtExpr).getResultExpr().getFullyConverted()
}

private predicate lvalueToReferenceStep(Expr lvalueIn, Expr referenceOut) {
  lvalueIn.getConversion() = referenceOut.(ReferenceToExpr)
}

private predicate referenceToLvalueStep(Expr referenceIn, Expr lvalueOut) {
  referenceIn.getConversion() = lvalueOut.(ReferenceDereferenceExpr)
}

private predicate referenceToPointerStep(Expr referenceIn, Expr pointerOut) {
  pointerOut =
    any(FunctionCall call |
      stdAddressOf(call.getTarget()) and
      referenceIn = call.getArgument(0).getFullyConverted()
    )
}

private predicate referenceToReferenceStep(Expr referenceIn, Expr referenceOut) {
  referenceOut =
    any(FunctionCall call |
      stdIdentityFunction(call.getTarget()) and
      referenceIn = call.getArgument(0).getFullyConverted()
    )
  or
  referenceIn.getConversion() = referenceOut.(Cast)
  or
  referenceIn.getConversion() = referenceOut.(ParenthesisExpr)
}

private predicate lvalueFromVariableAccess(VariableAccess va, Expr lvalue) {
  // Base case for non-reference types.
  lvalue = va and
  not va.getConversion() instanceof ReferenceDereferenceExpr
  or
  // Base case for reference types where we pretend that they are
  // non-reference types. The type of the target of `va` can be `ReferenceType`
  // or `FunctionReferenceType`.
  lvalue = va.getConversion().(ReferenceDereferenceExpr)
  or
  // lvalue -> lvalue
  exists(Expr prev |
    lvalueFromVariableAccess(va, prev) and
    lvalueToLvalueStep(prev, lvalue)
  )
  or
  // pointer -> lvalue
  exists(Expr prev |
    pointerFromVariableAccess(va, prev) and
    pointerToLvalueStep(prev, lvalue)
  )
  or
  // reference -> lvalue
  exists(Expr prev |
    referenceFromVariableAccess(va, prev) and
    referenceToLvalueStep(prev, lvalue)
  )
}

private predicate pointerFromVariableAccess(VariableAccess va, Expr pointer) {
  // pointer -> pointer
  exists(Expr prev |
    pointerFromVariableAccess(va, prev) and
    pointerToPointerStep(prev, pointer)
  )
  or
  // reference -> pointer
  exists(Expr prev |
    referenceFromVariableAccess(va, prev) and
    referenceToPointerStep(prev, pointer)
  )
  or
  // lvalue -> pointer
  exists(Expr prev |
    lvalueFromVariableAccess(va, prev) and
    lvalueToPointerStep(prev, pointer)
  )
}

private predicate referenceFromVariableAccess(VariableAccess va, Expr reference) {
  // reference -> reference
  exists(Expr prev |
    referenceFromVariableAccess(va, prev) and
    referenceToReferenceStep(prev, reference)
  )
  or
  // lvalue -> reference
  exists(Expr prev |
    lvalueFromVariableAccess(va, prev) and
    lvalueToReferenceStep(prev, reference)
  )
}

private predicate addressMayEscapeAt(Expr e) {
  exists(Call call |
    e = call.getAnArgument().getFullyConverted() and
    not stdIdentityFunction(call.getTarget()) and
    not stdAddressOf(call.getTarget())
    or
    e = call.getQualifier().getFullyConverted() and
    e.getUnderlyingType() instanceof PointerType
  )
  or
  exists(AssignExpr assign | e = assign.getRValue().getFullyConverted())
  or
  exists(Initializer init | e = init.getExpr().getFullyConverted())
  or
  exists(ConstructorFieldInit init | e = init.getExpr().getFullyConverted())
  or
  exists(ReturnStmt ret | e = ret.getExpr().getFullyConverted())
  or
  exists(ThrowExpr throw | e = throw.getExpr().getFullyConverted())
  or
  exists(AggregateLiteral agg | e = agg.getAChild().getFullyConverted())
  or
  exists(AsmStmt asm | e = asm.getAChild().(Expr).getFullyConverted())
}

private predicate addressMayEscapeMutablyAt(Expr e) {
  addressMayEscapeAt(e) and
  exists(Type t | t = e.getType().stripTopLevelSpecifiers() |
    t instanceof PointerType and
    not t.(PointerType).getBaseType().isConst()
    or
    t instanceof ReferenceType and
    not t.(ReferenceType).getBaseType().isConst()
    or
    // If the address has been cast to an integral type, conservatively assume that it may eventually be cast back to a
    // pointer to non-const type.
    t instanceof IntegralType
    or
    // If we go through a temporary object step, we can take a reference to a temporary const pointer
    // object, where the pointer doesn't point to a const value
    exists(TemporaryObjectExpr temp, PointerType pt |
      temp.getConversion() = e.(ReferenceToExpr) and
      pt = temp.getType().stripTopLevelSpecifiers()
    |
      not pt.getBaseType().isConst()
    )
  )
}

private predicate lvalueMayEscapeAt(Expr e) {
  // A call qualifier, like `q` in `q.f()`, is special in that the address of
  // `q` escapes even though `q` is not a pointer or a reference.
  exists(Call call |
    e = call.getQualifier().getFullyConverted() and
    e.getType().getUnspecifiedType() instanceof Class
  )
}

private predicate lvalueMayEscapeMutablyAt(Expr e) {
  lvalueMayEscapeAt(e) and
  // A qualifier of a call to a const member function is converted to a const
  // class type.
  not e.getType().isConst()
}

private predicate addressFromVariableAccess(VariableAccess va, Expr e) {
  pointerFromVariableAccess(va, e)
  or
  referenceFromVariableAccess(va, e)
  or
  // `e` could be a pointer that is converted to a reference as the final step,
  // meaning that we pass a value that is two dereferences away from referring
  // to `va`. This happens, for example, with `void std::vector::push_back(T&&
  // value);` when called as `v.push_back(&x)`, for a variable `x`. It
  // can also happen when taking a reference to a const pointer to a
  // (potentially non-const) value.
  exists(Expr pointerValue |
    pointerFromVariableAccess(va, pointerValue) and
    e = pointerValue.getConversion().(ReferenceToExpr)
  )
}

import EscapesTree_Cached

cached
private module EscapesTree_Cached {
  /**
   * Holds if `e` is a fully-converted expression that evaluates to an address
   * derived from the address of `va` and is stored in a variable or passed
   * across functions. This means `e` is the `Expr.getFullyConverted`-form of:
   *
   * - The right-hand side of an assignment or initialization;
   * - A function argument or return value;
   * - The argument to `throw`.
   * - An entry in an `AggregateLiteral`, including the compiler-generated
   *   `ClassAggregateLiteral` that initializes a `LambdaExpression`; or
   * - An expression in an inline assembly statement.
   *
   * This predicate includes pointers or reference to `const` types. See
   * `variableAddressEscapesTreeNonConst` for a version of this predicate that
   * does not.
   *
   * If `va` has reference type, the escape analysis concerns the value pointed
   * to by the reference rather than the reference itself. The C++ language does
   * not allow taking the address of a reference in any way, so this predicate
   * would never produce any results for the reference itself. Callers that are
   * not interested in the value referred to by references should exclude
   * variable accesses to reference-typed values.
   */
  cached
  predicate variableAddressEscapesTree(VariableAccess va, Expr e) {
    addressMayEscapeAt(e) and
    addressFromVariableAccess(va, e)
    or
    lvalueMayEscapeAt(e) and
    lvalueFromVariableAccess(va, e)
  }

  /**
   * Holds if `e` is a fully-converted expression that evaluates to a non-const
   * address derived from the address of `va` and is stored in a variable or
   * passed across functions. This means `e` is the `Expr.getFullyConverted`-form
   * of:
   *
   * - The right-hand side of an assignment or initialization;
   * - A function argument or return value;
   * - The argument to `throw`.
   * - An entry in an `AggregateLiteral`, including the compiler-generated
   *   `ClassAggregateLiteral` that initializes a `LambdaExpression`; or
   * - An expression in an inline assembly statement.
   *
   * This predicate omits pointers or reference to `const` types. See
   * `variableAddressEscapesTree` for a version of this predicate that includes
   * those.
   *
   * If `va` has reference type, the escape analysis concerns the value pointed
   * to by the reference rather than the reference itself. The C++ language
   * offers no way to take the address of a reference, so this predicate will
   * never produce any results for the reference itself. Callers that are not
   * interested in the value referred to by references should exclude variable
   * accesses to reference-typed values.
   */
  cached
  predicate variableAddressEscapesTreeNonConst(VariableAccess va, Expr e) {
    addressMayEscapeMutablyAt(e) and
    addressFromVariableAccess(va, e)
    or
    lvalueMayEscapeMutablyAt(e) and
    lvalueFromVariableAccess(va, e)
  }

  /**
   * Holds if `e` is a fully-converted expression that evaluates to an lvalue
   * derived from `va` and is used for reading from or assigning to. This is in
   * contrast with a variable access that is used for taking an address (`&x`)
   * or simply discarding its value (`x;`).
   *
   * This analysis does not propagate across assignments or calls. The analysis
   * is also not concerned with whether the lvalue `e` is converted to an rvalue
   * -- to examine that, use the relevant member predicates on `Expr`.
   *
   * If `va` has reference type, the analysis concerns the value pointed to by
   * the reference rather than the reference itself. The expression `e` may be a
   * `Conversion`.
   */
  cached
  predicate variableAccessedAsValue(VariableAccess va, Expr e) {
    lvalueFromVariableAccess(va, e) and
    not lvalueToLvalueStepPure(e, _) and
    not lvalueToPointerStep(e, _) and
    not lvalueToReferenceStep(e, _) and
    not e = any(ExprInVoidContext eivc | e = eivc.getConversion*())
  }
}
