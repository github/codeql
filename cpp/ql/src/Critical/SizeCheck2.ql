/**
 * @name Not enough memory allocated for array of pointer type
 * @description Calling 'malloc', 'calloc' or 'realloc' without allocating enough memory to contain
 *              multiple instances of the type of the pointer may result in a buffer overflow
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/suspicious-allocation-size
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
  // If the codebase has more than one type with the same name, check if any matches
  not exists(int size | base.getSize() = size |
    size = 0 or
    (allocated / size) * size = allocated
  ) and
  not basesize > allocated // covered by SizeCheck.ql
select alloc,
  "Allocated memory (" + allocated.toString() + " bytes) is not a multiple of the size of '" +
    base.getName() + "' (" + basesize.toString() + " bytes)."
