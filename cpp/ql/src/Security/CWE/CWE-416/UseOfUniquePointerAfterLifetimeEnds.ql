/**
 * @name Use of unique pointer after lifetime ends
 * @description Referencing the contents of a unique pointer after the underlying object has expired may lead to unexpected behavior.
 * @kind problem
 * @precision high
 * @id cpp/use-of-unique-pointer-after-lifetime-ends
 * @problem.severity warning
 * @security-severity 8.8
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 *       external/cwe/cwe-664
 */

import cpp
import semmle.code.cpp.models.interfaces.PointerWrapper
import Temporaries

predicate isUniquePointerDerefFunction(Function f) {
  exists(PointerWrapper wrapper |
    f = wrapper.getAnUnwrapperFunction() and
    // We only want unique pointers as the memory behind share pointers may still be
    // alive after the shared pointer is destroyed.
    wrapper.(Class).hasQualifiedName(["std", "bsl"], "unique_ptr")
  )
}

from Call c
where
  outlivesFullExpr(c) and
  not c.isFromUninstantiatedTemplate(_) and
  isUniquePointerDerefFunction(c.getTarget()) and
  // Exclude cases where the pointer is implicitly converted to a non-pointer type
  not c.getActualType() instanceof IntegralType and
  isTemporary(c.getQualifier().getFullyConverted())
select c,
  "The underlying unique pointer object is destroyed after the call to '" + c.getTarget() +
    "' returns."
