/**
 * Provides a local analysis for identifying where a variable address
 * is effectively taken. Array-like offsets are allowed to pass through but
 * not field-like offsets.
 *
 * This library is specialized to meet the needs of `FlowVar.qll`.
 */

/*
 * Maintainer note: this file is one of several files that are similar but not
 * identical. Many changes to this file will also apply to the others:
 * - AddressConstantExpression.qll
 * - AddressFlow.qll
 * - EscapesTree.qll
 */

private import cpp
private import semmle.code.cpp.models.interfaces.PointerWrapper

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
  or
  exists(PointerWrapper wrapper, Call call | call = referenceOut |
    referenceOut.getUnspecifiedType() instanceof ReferenceType and
    call = wrapper.getAnUnwrapperFunction().getACallToThisFunction() and
    lvalueIn = call.getQualifier().getFullyConverted()
  )
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
  or
  exists(CopyConstructor copy, Call call | call = pointerOut |
    copy.getDeclaringType() instanceof PointerWrapper and
    call.getTarget() = copy and
    // The 0'th argument is the value being copied.
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

private predicate assignmentTo(Expr updated, ControlFlowNode node) {
  updated = node.(Assignment).getLValue().getFullyConverted()
  or
  updated = node.(CrementOperation).getOperand().getFullyConverted()
}

private predicate lvalueToUpdate(Expr lvalue, Expr outer, ControlFlowNode node) {
  (
    exists(Call call | node = call |
      outer = call.getQualifier().getFullyConverted() and
      outer.getUnspecifiedType() instanceof Class and
      not (
        call.getTarget().hasSpecifier("const") and
        // Given the following program:
        // ```
        // struct C {
        //   void* data_;
        //   void* data() const { return data; }
        // };
        // C c;
        // memcpy(c.data(), source, 16)
        // ```
        // the data pointed to by `c.data_` is potentially modified by the call to `memcpy` even though
        // `C::data` has a const specifier. So we further place the restriction that the type returned
        // by `call` should not be of the form `const T*` (for some deeply const type `T`).
        call.getType().isDeeplyConstBelow()
      )
    )
    or
    assignmentTo(outer, node)
    or
    exists(DotFieldAccess fa |
      // `fa.otherField = ...` or `f(&fa)` or similar
      outer = fa.getQualifier().getFullyConverted() and
      valueToUpdate(fa, _, node)
    )
  ) and
  lvalue = outer
  or
  exists(Expr lvalueMid |
    lvalueToLvalueStep(lvalue, lvalueMid) and
    lvalueToUpdate(lvalueMid, outer, node)
  )
  or
  exists(Expr pointerMid |
    lvalueToPointerStep(lvalue, pointerMid) and
    pointerToUpdate(pointerMid, outer, node)
  )
  or
  exists(Expr referenceMid |
    lvalueToReferenceStep(lvalue, referenceMid) and
    referenceToUpdate(referenceMid, outer, node)
  )
}

private predicate pointerToUpdate(Expr pointer, Expr outer, ControlFlowNode node) {
  (
    exists(Call call | node = call |
      outer = call.getAnArgument().getFullyConverted() and
      exists(PointerType pt | pt = outer.getType().stripTopLevelSpecifiers() |
        not pt.getBaseType().isConst()
      )
      or
      outer = call.getQualifier().getFullyConverted() and
      outer.getUnspecifiedType() instanceof PointerType and
      not (
        call.getTarget().hasSpecifier("const") and
        // See the `lvalueToUpdate` case for an explanation of this conjunct.
        call.getType().isDeeplyConstBelow()
      )
      or
      // Pointer wrappers behave as raw pointers for dataflow purposes.
      outer = call.getAnArgument().getFullyConverted() and
      exists(PointerWrapper wrapper | wrapper = outer.getType().stripTopLevelSpecifiers() |
        not wrapper.pointsToConst()
      )
      or
      outer = call.getQualifier().getFullyConverted() and
      outer.getUnspecifiedType() instanceof PointerWrapper and
      not (
        call.getTarget().hasSpecifier("const") and
        call.getType().isDeeplyConstBelow()
      )
    )
    or
    exists(PointerFieldAccess fa |
      // `fa.otherField = ...` or `f(&fa)` or similar
      outer = fa.getQualifier().getFullyConverted() and
      valueToUpdate(fa, _, node)
    )
  ) and
  pointer = outer
  or
  exists(Expr lvalueMid |
    pointerToLvalueStep(pointer, lvalueMid) and
    lvalueToUpdate(lvalueMid, outer, node)
  )
  or
  exists(Expr pointerMid |
    pointerToPointerStep(pointer, pointerMid) and
    pointerToUpdate(pointerMid, outer, node)
  )
}

private predicate referenceToUpdate(Expr reference, Expr outer, ControlFlowNode node) {
  exists(Call call |
    node = call and
    outer = call.getAnArgument().getFullyConverted() and
    not stdIdentityFunction(call.getTarget()) and
    not stdAddressOf(call.getTarget()) and
    exists(ReferenceType rt | rt = outer.getType().stripTopLevelSpecifiers() |
      not rt.getBaseType().isConst() or
      rt.getBaseType().getUnspecifiedType() =
        any(PointerWrapper wrapper | not wrapper.pointsToConst())
    )
  ) and
  reference = outer
  or
  exists(Expr lvalueMid |
    referenceToLvalueStep(reference, lvalueMid) and
    lvalueToUpdate(lvalueMid, outer, node)
  )
  or
  exists(Expr pointerMid |
    referenceToPointerStep(reference, pointerMid) and
    pointerToUpdate(pointerMid, outer, node)
  )
  or
  exists(Expr referenceMid |
    referenceToReferenceStep(reference, referenceMid) and
    referenceToUpdate(referenceMid, outer, node)
  )
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

/**
 * Holds if `node` is a control-flow node that may modify `inner` (or what it
 * points to) through `outer`. The two expressions may be `Conversion`s. Plain
 * assignments to variables are not included in this predicate since they are
 * assumed to be analyzed by SSA or similar means.
 *
 * For example, in `f(& (*a).x)`, there are two results:
 * - `inner` = `... .x`, `outer` = `&...`, `node` = `f(...)`.
 * - `inner` = `a`, `outer` = `(...)`, `node` = `f(...)`.
 */
cached
predicate valueToUpdate(Expr inner, Expr outer, ControlFlowNode node) {
  (
    lvalueToUpdate(inner, outer, node)
    or
    pointerToUpdate(inner, outer, node)
    or
    referenceToUpdate(inner, outer, node)
  ) and
  (
    inner instanceof VariableAccess and
    // Don't track non-field assignments
    not (assignmentTo(outer, _) and outer.(VariableAccess).getTarget() instanceof StackVariable)
    or
    inner instanceof ThisExpr
    or
    inner instanceof Call
    // `inner` could also be `*` or `ReferenceDereferenceExpr`, but we
    // can't do anything useful with those at the moment.
  )
}

/**
 * Holds if `e` is a fully-converted expression that evaluates to an lvalue
 * derived from `va` and is used for reading from or assigning to. This is in
 * contrast with a variable access that is used for taking an address (`&x`)
 * or simply discarding its value (`x;`).
 *
 * This analysis does not propagate across assignments or calls, and unlike
 * `variableAccessedAsValue` in `semmle.code.cpp.dataflow.EscapesTree` it
 * propagates through array accesses but not field accesses. The analysis is
 * also not concerned with whether the lvalue `e` is converted to an rvalue --
 * to examine that, use the relevant member predicates on `Expr`.
 *
 * If `va` has reference type, the analysis concerns the value pointed to by
 * the reference rather than the reference itself. The expression `e` may be a
 * `Conversion`.
 */
predicate variablePartiallyAccessed(VariableAccess va, Expr e) {
  lvalueFromVariableAccess(va, e) and
  not lvalueToLvalueStepPure(e, _) and
  not lvalueToPointerStep(e, _) and
  not lvalueToReferenceStep(e, _) and
  not e = any(ExprInVoidContext eivc | e = eivc.getConversion*())
}
