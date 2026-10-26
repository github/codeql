/**
 * @name Not enough memory allocated for pointer type
 * @description Calling 'malloc', 'calloc' or 'realloc' without allocating enough memory to contain
 *              an instance of the type of the pointer may result in a buffer overflow
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision medium
 * @id cpp/allocation-too-small
 * @tags reliability
 *       security
 *       external/cwe/cwe-131
 *       external/cwe/cwe-122
 */

import cpp
import semmle.code.cpp.models.Models

predicate baseType(AllocationExpr alloc, Type base) {
  exists(PointerType pointer |
    pointer.getBaseType() = base and
    (
      exists(AssignExpr assign |
        assign.getRValue() = alloc and assign.getLValue().getType() = pointer
      )
      or
      exists(Variable v | v.getInitializer().getExpr() = alloc and v.getType() = pointer)
    )
  )
}

predicate decideOnSize(Type t, int size) {
  // If the codebase has more than one type with the same name, it can have more than one size.
  size = min(t.getSize())
}

from AllocationExpr alloc, Type base, int basesize, int allocated
where
  baseType(alloc, base) and
  allocated = alloc.getSizeBytes() and
  decideOnSize(base, basesize) and
  alloc.(FunctionCall).getTarget() instanceof AllocationFunction and // exclude `new` and similar
  basesize > allocated
select alloc,
  "Type '" + base.getName() + "' is " + basesize.toString() + " bytes, but only " +
    allocated.toString() + " bytes are allocated."
