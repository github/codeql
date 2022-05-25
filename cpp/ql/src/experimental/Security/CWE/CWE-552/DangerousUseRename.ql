/**
 * @name Dangerous use of rename
 * @description If the rename function did not work correctly, attempting to copy the contents of a source file by opening the target file without assessing permissions creates a mechanism for deleting an arbitrary system file.
 * @kind problem
 * @id cpp/dangerous-manual-copy-after-rename
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

from FunctionCall renameCall
where
  renameCall.getTarget().hasName("rename") and
  exists(IfStmt ifst, Expr ec, Expr ecd, FunctionCall readCall, FunctionCall writeCall |
    findFileForReadOrWrite(renameCall, readCall, "r", 0) and
    findFileForReadOrWrite(renameCall, writeCall, "w", 1) and
    ecd = ifst.getCondition().getAChild*() and
    (
      globalValueNumber(ecd) = globalValueNumber(renameCall) and
      not ecd.getParent() instanceof ComparisonOperation and
      not ecd.getParent() instanceof NotExpr
      or
      exists(Expr evp |
        globalValueNumber(evp) = globalValueNumber(renameCall) and
        ecd.(ComparisonOperation).hasOperands(evp, _)
      )
    ) and
    (
      ec.getValue() = "0" and
      ecd.(EQExpr).hasOperands(_, ec) and
      forall(Expr st | st = ifst.getThen().getASuccessor*() | st != readCall) and
      forall(Expr st | st = ifst.getThen().getASuccessor*() | st != writeCall)
      or
      (
        not ecd instanceof EQExpr
        or
        not ecd.(EQExpr).getLeftOperand().getValue() = "0" and
        not ecd.(EQExpr).getRightOperand().getValue() = "0"
      ) and
      ifst.getThen() = readCall.getEnclosingStmt().getParentStmt*() and
      ifst.getThen() = writeCall.getEnclosingStmt().getParentStmt*()
    )
  )
select renameCall,
  "If the rename function did not work correctly, attempting to copy the contents of a source file by opening the target file without assessing permissions creates a mechanism for deleting an arbitrary system file."
