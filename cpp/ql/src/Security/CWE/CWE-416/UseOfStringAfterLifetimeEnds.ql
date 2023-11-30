/**
 * @name Use of string after lifetime ends
 * @description If the value of a call to 'c_str' outlives the underlying object it may lead to unexpected behavior.
 * @kind problem
 * @precision high
 * @id cpp/use-of-string-after-lifetime-ends
 * @problem.severity warning
 * @security-severity 8.8
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 *       external/cwe/cwe-664
 */

import cpp
import semmle.code.cpp.models.implementations.StdString
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
 * Holds if the value of `e` outlives the enclosing full expression. For
 * example, because the value is stored in a local variable.
 */
predicate outlivesFullExpr(Expr e) {
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
    bin.getAnOperand() = e
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
}

from Call c
where
  outlivesFullExpr(c) and
  not c.isFromUninstantiatedTemplate(_) and
  (c.getTarget() instanceof StdStringCStr or c.getTarget() instanceof StdStringData) and
  isTemporary(c.getQualifier().getFullyConverted())
select c,
  "The underlying string object is destroyed after the call to '" + c.getTarget() + "' returns."
