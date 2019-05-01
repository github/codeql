/**
 * @name Buffer not sufficient for string
 * @description A buffer allocated using 'malloc' may not have enough space for a string that is being copied into it. The operation can cause a buffer overrun. Make sure that the buffer contains enough room for the string (including the zero terminator).
 * @kind problem
 * @id cpp/overflow-calculated
 * @problem.severity warning
 * @tags reliability
 *       security
 *       external/cwe/cwe-131
 *       external/cwe/cwe-120
 */

import cpp

class MallocCall extends FunctionCall {
  MallocCall() {
    this.getTarget().hasQualifiedName("malloc") or
    this.getTarget().hasQualifiedName("std::malloc")
  }

  Expr getAllocatedSize() {
    if this.getArgument(0) instanceof VariableAccess
    then
      exists(LocalScopeVariable v, ControlFlowNode def |
        definitionUsePair(v, def, this.getArgument(0)) and
        exprDefinition(v, def, result)
      )
    else result = this.getArgument(0)
  }
}

predicate spaceProblem(FunctionCall append, string msg) {
  exists(MallocCall malloc, StrlenCall strlen, AddExpr add, FunctionCall insert, Variable buffer |
    add.getAChild() = strlen and
    exists(add.getAChild().getValue()) and
    malloc.getAllocatedSize() = add and
    buffer.getAnAccess() = strlen.getStringExpr() and
    (
      insert.getTarget().hasQualifiedName("strcpy") or
      insert.getTarget().hasQualifiedName("strncpy")
    ) and
    (
      append.getTarget().hasQualifiedName("strcat") or
      append.getTarget().hasQualifiedName("strncat")
    ) and
    malloc.getASuccessor+() = insert and
    insert.getArgument(1) = buffer.getAnAccess() and
    insert.getASuccessor+() = append and
    msg = "This buffer only contains enough room for '" + buffer.getName() + "' (copied on line " +
        insert.getLocation().getStartLine().toString() + ")"
  )
}

from Expr problem, string msg
where spaceProblem(problem, msg)
select problem, msg
