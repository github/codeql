/**
 * @name Overflow in uncontrolled allocation size
 * @description Allocating memory with a size controlled by an external
 *              user can result in integer overflow.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/uncontrolled-allocation-size
 * @tags reliability
 *       security
 *       external/cwe/cwe-190
 */

import cpp
import semmle.code.cpp.security.TaintTracking

predicate taintedAllocSize(Expr e, Expr source, string taintCause) {
  (
    isAllocationExpr(e) or
    any(MulExpr me | me.getAChild() instanceof SizeofOperator) = e
  ) and
  exists(Expr tainted |
    tainted = e.getAChild() and
    tainted.getUnspecifiedType() instanceof IntegralType and
    isUserInput(source, taintCause) and
    tainted(source, tainted)
  )
}

from Expr e, Expr source, string taintCause
where taintedAllocSize(e, source, taintCause)
select e, "This allocation size is derived from $@ and might overflow", source,
  "user input (" + taintCause + ")"
