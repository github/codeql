import cpp
import semmle.code.cpp.models.implementations.StdContainer

/**
 * Holds if `e` will be consumed by its parent as a glvalue and does not have
 * an lvalue-to-rvalue conversion. This means that it will be materialized into
 * a temporary object.
 */
predicate isTemporary(Expr e) {
  e instanceof TemporaryObjectExpr
  or
  e.isPRValueCategory() and
  e.getUnspecifiedType() instanceof Class and
  not e.hasLValueToRValueConversion()
}

/** Holds if `e` is written to a container. */
predicate isStoredInContainer(Expr e) {
  exists(StdSequenceContainerInsert insert, Call call, int index |
    call = insert.getACallToThisFunction() and
    index = insert.getAValueTypeParameterIndex() and
    call.getArgument(index) = e
  )
  or
  exists(StdSequenceContainerPush push, Call call, int index |
    call = push.getACallToThisFunction() and
    index = push.getAValueTypeParameterIndex() and
    call.getArgument(index) = e
  )
  or
  exists(StdSequenceEmplace emplace, Call call, int index |
    call = emplace.getACallToThisFunction() and
    index = emplace.getAValueTypeParameterIndex() and
    call.getArgument(index) = e
  )
  or
  exists(StdSequenceEmplaceBack emplaceBack, Call call, int index |
    call = emplaceBack.getACallToThisFunction() and
    index = emplaceBack.getAValueTypeParameterIndex() and
    call.getArgument(index) = e
  )
}

/**
 * Holds if `e` or a conversion of `e` has an lvalue-to-rvalue conversion.
 */
private predicate hasLValueToRValueConversion(Expr e) {
  e.getConversion*().hasLValueToRValueConversion() and
  not e instanceof ConditionalExpr // ConditionalExpr may be spuriously reported as having an lvalue-to-rvalue conversion
}

/**
 * Holds if the value of `e` outlives the enclosing full expression. For
 * example, because the value is stored in a local variable.
 */
predicate outlivesFullExpr(Expr e) {
  not hasLValueToRValueConversion(e) and
  (
    any(Assignment assign).getRValue() = e
    or
    any(Variable v).getInitializer().getExpr() = e
    or
    any(ReturnStmt ret).getExpr() = e
    or
    exists(ConditionalExpr cond |
      outlivesFullExpr(cond) and
      [cond.getThen(), cond.getElse()] = e
    )
    or
    exists(BinaryOperation bin |
      outlivesFullExpr(bin) and
      bin.getAnOperand() = e and
      not bin instanceof ComparisonOperation
    )
    or
    exists(PointerFieldAccess fa |
      outlivesFullExpr(fa) and
      fa.getQualifier() = e
    )
    or
    exists(AddressOfExpr ao |
      outlivesFullExpr(ao) and
      ao.getOperand() = e
    )
    or
    exists(ClassAggregateLiteral aggr |
      outlivesFullExpr(aggr) and
      aggr.getAFieldExpr(_) = e
    )
    or
    exists(ArrayAggregateLiteral aggr |
      outlivesFullExpr(aggr) and
      aggr.getAnElementExpr(_) = e
    )
    or
    isStoredInContainer(e)
  )
}
