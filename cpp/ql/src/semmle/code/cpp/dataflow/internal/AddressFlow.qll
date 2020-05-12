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

private predicate lvalueToLvalueStep(Expr lvalueIn, Expr lvalueOut) {
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
      not call.getTarget().hasSpecifier("const")
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
      not call.getTarget().hasSpecifier("const")
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
      not rt.getBaseType().isConst()
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
    (assignmentTo(outer, _) implies inner instanceof FieldAccess)
    or
    inner instanceof ThisExpr
    or
    inner instanceof Call
    // `inner` could also be `*` or `ReferenceDereferenceExpr`, but we
    // can't do anything useful with those at the moment.
  )
}
