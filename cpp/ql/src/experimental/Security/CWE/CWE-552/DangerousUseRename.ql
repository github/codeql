/**
 * @name Dangerous use rename.
 * @description If the rename function did not work correctly, simply overwriting the destination file can lead to errors.
 * @kind problem
 * @id cpp/dangerous-use-rename
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-552
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/** Holds if the function argument is used in opening the file for reading or writing. */
predicate findFileForReadOrWrite(FunctionCall fc, FunctionCall fc1, string mode, int na) {
  fc1.getTarget().hasName(["open", "fopen"]) and
  globalValueNumber(fc1.getArgument(0)) = globalValueNumber(fc.getArgument(na)) and
  fc1.getArgument(1).getValue() = mode and
  fc.getASuccessor+() = fc1
}

from FunctionCall fc
where
  fc.getTarget().hasName("rename") and
  exists(IfStmt ifst, Expr ec, Expr ecd, FunctionCall fc1, FunctionCall fc2 |
    findFileForReadOrWrite(fc, fc1, "r", 0) and
    findFileForReadOrWrite(fc, fc2, "w", 1) and
    ec.getValue() = "0" and
    ecd = ifst.getCondition().getAChild*() and
    (
      globalValueNumber(ecd) = globalValueNumber(fc) and
      not ecd.getParent() instanceof ComparisonOperation
      or
      exists(Expr evp |
        globalValueNumber(evp) = globalValueNumber(fc) and
        ecd.(ComparisonOperation).hasOperands(evp, _)
      )
    ) and
    (
      ecd.(EQExpr).hasOperands(_, ec) and
      forall(Expr st | st = ifst.getThen().getASuccessor*() | st != fc1) and
      forall(Expr st | st = ifst.getThen().getASuccessor*() | st != fc2)
      or
      (
        not ecd instanceof EQExpr
        or
        not ecd.(EQExpr).getLeftOperand().getValue() = "0" and
        not ecd.(EQExpr).getRightOperand().getValue() = "0"
      ) and
      ifst.getThen() = fc1.getEnclosingStmt().getParentStmt*() and
      ifst.getThen() = fc2.getEnclosingStmt().getParentStmt*()
    )
  )
select fc,
  "If the rename function did not work correctly, simply overwriting the destination file can lead to errors."
