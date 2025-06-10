/**
 * @name Buffer overflow from insufficient space or incorrect size calculation
 * @description A buffer allocated using 'malloc' may not have enough space for a string being copied into it, or wide character functions may receive incorrect size parameters causing buffer overrun. Make sure that buffers contain enough room for strings (including zero terminator) and that size parameters are correctly calculated.
 * @kind problem
 * @precision medium
 * @id cpp/overflow-calculated
 * @problem.severity warning
 * @security-severity 9.8
 * @tags reliability
 *       security
 *       external/cwe/cwe-131
 *       external/cwe/cwe-120
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.models.interfaces.Allocation

predicate spaceProblem(FunctionCall append, string msg) {
  exists(
    AllocationExpr malloc, StrlenCall strlen, AddExpr add, FunctionCall insert, Variable buffer
  |
    add.getAChild() = strlen and
    exists(add.getAChild().getValue()) and
    DataFlow::localExprFlow(add, malloc.getSizeExpr()) and
    buffer.getAnAccess() = strlen.getStringExpr() and
    (
      insert.getTarget().hasGlobalOrStdName("strcpy") or
      insert.getTarget().hasGlobalOrStdName("strncpy")
    ) and
    (
      append.getTarget().hasGlobalOrStdName("strcat") or
      append.getTarget().hasGlobalOrStdName("strncat")
    ) and
    malloc.getASuccessor+() = insert and
    insert.getArgument(1) = buffer.getAnAccess() and
    insert.getASuccessor+() = append and
    msg =
      "This buffer only contains enough room for '" + buffer.getName() + "' (copied on line " +
        insert.getLocation().getStartLine().toString() + ")"
  )
}

predicate wideCharSizeofProblem(FunctionCall call, string msg) {
  exists(
    Variable buffer, SizeofExprOperator sizeofOp, ArrayType arrayType
  |
    // Function call is to wcsftime
    call.getTarget().hasGlobalOrStdName("wcsftime") and
    // Second argument (count parameter) is a sizeof operation
    call.getArgument(1) = sizeofOp and
    // The sizeof is applied to a buffer variable
    sizeofOp.getExprOperand() = buffer.getAnAccess() and
    // The buffer is an array of wchar_t
    arrayType = buffer.getType() and
    arrayType.getBaseType().hasName("wchar_t") and
    msg =
      "Using sizeof(" + buffer.getName() + ") passes byte count instead of wchar_t element count to wcsftime. " +
      "Use sizeof(" + buffer.getName() + ")/sizeof(wchar_t) or array length instead."
  )
}

from Expr problem, string msg
where spaceProblem(problem, msg) or wideCharSizeofProblem(problem, msg)
select problem, msg
