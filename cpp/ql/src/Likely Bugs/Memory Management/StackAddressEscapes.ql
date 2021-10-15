/**
 * @name Local variable address stored in non-local memory
 * @description Storing the address of a local variable in non-local
 *              memory can cause a dangling pointer bug if the address
 *              is used after the function returns.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/stack-address-escape
 * @tags reliability
 */

import cpp
import semmle.code.cpp.dataflow.StackAddress

/**
 * Find assignments where the rhs might be a stack pointer and the lhs is
 * not a stack variable. Such assignments might allow a stack address to
 * escape.
 */
predicate stackAddressEscapes(AssignExpr assignExpr, Expr source, boolean isLocal) {
  stackPointerFlowsToUse(assignExpr.getRValue(), _, source, isLocal) and
  not stackReferenceFlowsToUse(assignExpr.getLValue(), _, _, _)
}

from Expr use, Expr source, boolean isLocal, string msg, string srcStr
where
  stackAddressEscapes(use, source, isLocal) and
  if isLocal = true
  then (
    msg = "A stack address ($@) may be assigned to a non-local variable." and
    srcStr = "source"
  ) else (
    msg = "A stack address which arrived via a $@ may be assigned to a non-local variable." and
    srcStr = "parameter"
  )
select use, msg, source, srcStr
