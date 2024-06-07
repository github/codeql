/**
 * @name Integer addition may overflow inside if statement
 * @description Writing 'if (a+b>c) a=c-b' incorrectly implements
 *              'a = min(a,c-b)' if 'a+b' overflows. This integer
 *              overflow is the root cause of the buffer overflow
 *              in the SHA-3 reference implementation (CVE-2022-37454).
 * @kind problem
 * @problem.severity warning
 * @id cpp/if-statement-addition-overflow
 * @tags: experimental
 *        correctness
 *        security
 *        external/cwe/cwe-190
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.valuenumbering.HashCons
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.controlflow.Guards

from
  GuardCondition guard, Expr expr, ExprStmt exprstmt, BasicBlock block, AssignExpr assignexpr,
  AddExpr addexpr, SubExpr subexpr
where
  (guard.ensuresLt(expr, addexpr, 0, block, _) or guard.ensuresLt(addexpr, expr, 0, block, _)) and
  addexpr.getUnspecifiedType() instanceof IntegralType and
  exprMightOverflowPositively(addexpr) and
  block.getANode() = exprstmt and
  exprstmt.getExpr() = assignexpr and
  assignexpr.getRValue() = subexpr and
  (
    hashCons(addexpr.getLeftOperand()) = hashCons(assignexpr.getLValue()) and
    globalValueNumber(addexpr.getRightOperand()) = globalValueNumber(subexpr.getRightOperand())
    or
    hashCons(addexpr.getRightOperand()) = hashCons(assignexpr.getLValue()) and
    globalValueNumber(addexpr.getLeftOperand()) = globalValueNumber(subexpr.getRightOperand())
  ) and
  globalValueNumber(expr) = globalValueNumber(subexpr.getLeftOperand())
select guard,
  "\"if (a+b>c) a=c-b\" was detected where the $@ may potentially overflow/wraparound. The code can be rewritten as \"if (a>c-b) a=c-b\" which avoids the overflow.",
  addexpr, "addition"
