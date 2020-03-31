/**
 * @name Not enough memory allocated for pointer type
 * @description Calling 'malloc', 'calloc' or 'realloc' without allocating enough memory to contain
 *              an instance of the type of the pointer may result in a buffer overflow
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/allocation-too-small
 * @tags reliability
 *       security
 *       external/cwe/cwe-131
 *       external/cwe/cwe-122
 */

import cpp

class Allocation extends FunctionCall {
  Allocation() {
    exists(string name |
      this.getTarget().hasGlobalOrStdName(name) and
      (name = "malloc" or name = "calloc" or name = "realloc")
    )
  }

  private string getName() { this.getTarget().hasGlobalOrStdName(result) }

  int getSize() {
    this.getName() = "malloc" and
    this.getArgument(0).getValue().toInt() = result
    or
    this.getName() = "realloc" and
    this.getArgument(1).getValue().toInt() = result
    or
    this.getName() = "calloc" and
    result = this.getArgument(0).getValue().toInt() * this.getArgument(1).getValue().toInt()
  }
}

predicate baseType(Allocation alloc, Type base) {
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

from Allocation alloc, Type base, int basesize, int allocated
where
  baseType(alloc, base) and
  allocated = alloc.getSize() and
  decideOnSize(base, basesize) and
  basesize > allocated
select alloc,
  "Type '" + base.getName() + "' is " + basesize.toString() + " bytes, but only " +
    allocated.toString() + " bytes are allocated."
