/**
 * @name Incorrect switch statement
 * @description --Finding places the dangerous use of a switch.
 *              --For example, when the range of values for a condition does not cover all of the selection values..
 * @kind problem
 * @id cpp/operator-find-incorrectly-used-switch
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-561
 *       external/cwe/cwe-691
 *       external/cwe/cwe-478
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/** Holds if the range contains no boundary values. */
predicate isRealRange(Expr exp) {
  upperBound(exp).toString() != "18446744073709551616" and
  upperBound(exp).toString() != "9223372036854775807" and
  upperBound(exp).toString() != "4294967295" and
  upperBound(exp).toString() != "Infinity" and
  upperBound(exp).toString() != "NaN" and
  lowerBound(exp).toString() != "-9223372036854775808" and
  lowerBound(exp).toString() != "-4294967296" and
  lowerBound(exp).toString() != "-Infinity" and
  lowerBound(exp).toString() != "NaN" and
  upperBound(exp) != 2147483647 and
  upperBound(exp) != 268435455 and
  upperBound(exp) != 33554431 and
  upperBound(exp) != 8388607 and
  upperBound(exp) != 65535 and
  upperBound(exp) != 32767 and
  upperBound(exp) != 255 and
  upperBound(exp) != 127 and
  upperBound(exp) != 63 and
  upperBound(exp) != 31 and
  upperBound(exp) != 15 and
  upperBound(exp) != 7 and
  lowerBound(exp) != -2147483648 and
  lowerBound(exp) != -268435456 and
  lowerBound(exp) != -33554432 and
  lowerBound(exp) != -8388608 and
  lowerBound(exp) != -65536 and
  lowerBound(exp) != -32768 and
  lowerBound(exp) != -128
}

/** Holds if the range of values for the condition is less than the choices. */
predicate isNotAllSelected(SwitchStmt swtmp) {
  not swtmp.getExpr().isConstant() and
  exists(int i |
    i != 0 and
    (
      i = lowerBound(swtmp.getASwitchCase().getExpr()) and
      upperBound(swtmp.getExpr()) < i
      or
      (
        i = upperBound(swtmp.getASwitchCase().getExpr()) or
        i = upperBound(swtmp.getASwitchCase().getEndExpr())
      ) and
      lowerBound(swtmp.getExpr()) > i
    )
  )
}

/** Holds if the range of values for the condition is greater than the selection. */
predicate isConditionBig(SwitchStmt swtmp) {
  not swtmp.hasDefaultCase() and
  not exists(int iu, int il |
    (
      iu = upperBound(swtmp.getASwitchCase().getExpr()) or
      iu = upperBound(swtmp.getASwitchCase().getEndExpr())
    ) and
    upperBound(swtmp.getExpr()) = iu and
    (
      il = lowerBound(swtmp.getASwitchCase().getExpr()) or
      il = lowerBound(swtmp.getASwitchCase().getEndExpr())
    ) and
    lowerBound(swtmp.getExpr()) = il
  )
}

/** Holds if there are labels inside the block with names similar to `default` or `case`. */
predicate isWrongLableName(SwitchStmt swtmp) {
  not swtmp.hasDefaultCase() and
  exists(LabelStmt lb |
    (
      (
        lb.getName().charAt(0) = "d" or
        lb.getName().charAt(0) = "c"
      ) and
      (
        lb.getName().charAt(1) = "e" or
        lb.getName().charAt(1) = "a"
      ) and
      (
        lb.getName().charAt(2) = "f" or
        lb.getName().charAt(2) = "s"
      )
    ) and
    lb.getEnclosingStmt().getParentStmt*() = swtmp.getStmt() and
    not exists(GotoStmt gs | gs.getName() = lb.getName())
  )
}

/** Holds if the block contains code before the first `case`. */
predicate isCodeBeforeCase(SwitchStmt swtmp) {
  exists(Expr exp |
    exp.getEnclosingStmt().getParentStmt*() = swtmp.getStmt() and
    not exists(Loop lp |
      exp.getEnclosingStmt().getParentStmt*() = lp and
      lp.getEnclosingStmt().getParentStmt*() = swtmp.getStmt()
    ) and
    not exists(Stmt sttmp, SwitchCase sctmp |
      sttmp = swtmp.getASwitchCase().getAStmt() and
      sctmp = swtmp.getASwitchCase() and
      (
        exp.getEnclosingStmt().getParentStmt*() = sttmp or
        exp.getEnclosingStmt() = sctmp
      )
    )
  )
}

from SwitchStmt sw, string msg
where
  isRealRange(sw.getExpr()) and
  lowerBound(sw.getExpr()) != upperBound(sw.getExpr()) and
  lowerBound(sw.getExpr()) != 0 and
  not exists(Expr cexp |
    cexp = sw.getASwitchCase().getExpr() and not isRealRange(cexp)
    or
    cexp = sw.getASwitchCase().getEndExpr() and not isRealRange(cexp)
  ) and
  not exists(Expr exptmp |
    exptmp = sw.getExpr().getAChild*() and
    not exptmp.isConstant() and
    not isRealRange(exptmp)
  ) and
  (sw.getASwitchCase().terminatesInBreakStmt() or sw.getASwitchCase().terminatesInReturnStmt()) and
  (
    isNotAllSelected(sw) and msg = "The range of condition values is less than the selection."
    or
    isConditionBig(sw) and msg = "The range of condition values is wider than the choices."
  )
  or
  isWrongLableName(sw) and msg = "Possibly erroneous label name."
  or
  isCodeBeforeCase(sw) and msg = "Code before case will not be executed."
select sw, msg
