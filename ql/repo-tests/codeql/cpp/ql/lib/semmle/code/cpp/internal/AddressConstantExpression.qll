/*
 * Maintainer note: this file is one of several files that are similar but not
 * identical. Many changes to this file will also apply to the others:
 * - AddressConstantExpression.qll
 * - AddressFlow.qll
 * - EscapesTree.qll
 */

private import cpp

predicate addressConstantExpression(Expr e) {
  constantAddressPointer(e)
  or
  constantAddressReference(e)
  or
  // Special case for function pointers, where `fp == *fp`.
  constantAddressLValue(e) and
  e.getType() instanceof FunctionPointerType
}

/** Holds if `v` is a constexpr variable initialized to a constant address. */
private predicate addressConstantVariable(Variable v) {
  addressConstantExpression(v.getInitializer().getExpr().getFullyConverted()) and
  v.isConstexpr()
}

/**
 * Holds if `lvalue` is an lvalue whose address is an _address constant
 * expression_.
 */
private predicate constantAddressLValue(Expr lvalue) {
  lvalue.(VariableAccess).getTarget() =
    any(Variable v |
      v.isStatic()
      or
      v instanceof GlobalOrNamespaceVariable
    )
  or
  // There is no `Conversion` for the implicit conversion from a function type
  // to a function _pointer_ type. Instead, the type of a `FunctionAccess`
  // tells us how it's going to be used.
  lvalue.(FunctionAccess).getType() instanceof RoutineType
  or
  // Pointer-to-member literals in uninstantiated templates
  lvalue instanceof Literal and
  not exists(lvalue.getValue()) and
  lvalue.isFromUninstantiatedTemplate(_)
  or
  // String literals have array types and undergo array-to-pointer conversion.
  lvalue instanceof StringLiteral
  or
  // lvalue -> lvalue
  exists(Expr prev |
    constantAddressLValue(prev) and
    lvalueToLvalueStep(prev, lvalue)
  )
  or
  // pointer -> lvalue
  exists(Expr prev |
    constantAddressPointer(prev) and
    pointerToLvalueStep(prev, lvalue)
  )
  or
  // reference -> lvalue
  exists(Expr prev |
    constantAddressReference(prev) and
    referenceToLvalueStep(prev, lvalue)
  )
}

/** Holds if `pointer` is an _address constant expression_ of pointer type. */
private predicate constantAddressPointer(Expr pointer) {
  // There is no `Conversion` for the implicit conversion from a function type
  // to a function _pointer_ type. Instead, the type of a `FunctionAccess`
  // tells us how it's going to be used.
  pointer.(FunctionAccess).getType() instanceof FunctionPointerType
  or
  // Pointer to member function. These accesses are always pointers even though
  // their type is `RoutineType`.
  pointer.(FunctionAccess).getTarget() instanceof MemberFunction
  or
  addressConstantVariable(pointer.(VariableAccess).getTarget()) and
  pointer.getType().getUnderlyingType() instanceof PointerType
  or
  // pointer -> pointer
  exists(Expr prev |
    constantAddressPointer(prev) and
    pointerToPointerStep(prev, pointer)
  )
  or
  // lvalue -> pointer
  exists(Expr prev |
    constantAddressLValue(prev) and
    lvalueToPointerStep(prev, pointer)
  )
}

/** Holds if `reference` is an _address constant expression_ of reference type. */
private predicate constantAddressReference(Expr reference) {
  addressConstantVariable(reference.(VariableAccess).getTarget()) and
  reference.getType().getUnderlyingType() instanceof ReferenceType
  or
  addressConstantVariable(reference.(VariableAccess).getTarget()) and
  reference.getType().getUnderlyingType() instanceof FunctionReferenceType // not a ReferenceType
  or
  // reference -> reference
  exists(Expr prev |
    constantAddressReference(prev) and
    referenceToReferenceStep(prev, reference)
  )
  or
  // lvalue -> reference
  exists(Expr prev |
    constantAddressLValue(prev) and
    lvalueToReferenceStep(prev, reference)
  )
}

private predicate lvalueToLvalueStep(Expr lvalueIn, Expr lvalueOut) {
  lvalueIn = lvalueOut.(DotFieldAccess).getQualifier().getFullyConverted()
  or
  lvalueIn.getConversion() = lvalueOut.(ParenthesisExpr)
  or
  // Special case for function pointers, where `fp == *fp`.
  lvalueIn = lvalueOut.(PointerDereferenceExpr).getOperand().getFullyConverted() and
  lvalueIn.getType() instanceof FunctionPointerType
}

private predicate pointerToLvalueStep(Expr pointerIn, Expr lvalueOut) {
  lvalueOut =
    any(ArrayExpr ae |
      pointerIn = ae.getArrayBase().getFullyConverted() and
      hasConstantValue(ae.getArrayOffset().getFullyConverted())
    )
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
  pointerIn.getUnspecifiedType() instanceof PointerType and
  // The pointer arg won't be constant in the sense of `hasConstantValue`, so
  // this will have to match the integer argument.
  hasConstantValue(pointerOut.getAChild().getFullyConverted())
  or
  pointerIn = pointerOut.(UnaryPlusExpr).getOperand().getFullyConverted()
  or
  pointerIn.getConversion() = pointerOut.(Cast)
  or
  pointerIn.getConversion() = pointerOut.(ParenthesisExpr)
  or
  pointerOut =
    any(ConditionalExpr cond |
      cond.getCondition().getFullyConverted().getValue().toInt() != 0 and
      pointerIn = cond.getThen().getFullyConverted()
      or
      cond.getCondition().getFullyConverted().getValue().toInt() = 0 and
      pointerIn = cond.getElse().getFullyConverted()
    )
  or
  // The comma operator is allowed by C++17 but disallowed by C99. This
  // disjunct is a compromise that's chosen for being easy to implement.
  pointerOut =
    any(CommaExpr comma |
      hasConstantValue(comma.getLeftOperand()) and
      pointerIn = comma.getRightOperand().getFullyConverted()
    )
}

private predicate lvalueToReferenceStep(Expr lvalueIn, Expr referenceOut) {
  lvalueIn.getConversion() = referenceOut.(ReferenceToExpr)
}

private predicate referenceToLvalueStep(Expr referenceIn, Expr lvalueOut) {
  // This probably cannot happen. It would require an expression to be
  // converted to a reference and back again without an intermediate variable
  // assignment.
  referenceIn.getConversion() = lvalueOut.(ReferenceDereferenceExpr)
}

private predicate referenceToReferenceStep(Expr referenceIn, Expr referenceOut) {
  referenceIn.getConversion() = referenceOut.(Cast)
  or
  referenceIn.getConversion() = referenceOut.(ParenthesisExpr)
}

/** Holds if `e` is constant according to the database. */
private predicate hasConstantValue(Expr e) { valuebind(_, underlyingElement(e)) }
