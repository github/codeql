/**
 * @name Integer addition may overflow inside if statement
 * @description Detects "if (a+b>c) a=c-b", which incorrectly implements
 *              a = min(a,c-b) if a+b overflows. Should be replaced by
 *              "if (a>c-b) a=c-b". Also detects "if (b+a>c) a=c-b"
 *              (swapped terms in addition), if (a+b>c) { a=c-b }"
 *              (assignment inside block), "c<a+b" (swapped operands) and
 *              ">=", "<", "<=" instead of ">" (all operators). This
 *              integer overflow is the root cause of the buffer overflow
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
import semmle.code.cpp.commons.Exclusions

from IfStmt ifstmt, RelationalOperation relop, ExprStmt exprstmt, BlockStmt blockstmt, AssignExpr assignexpr, AddExpr addexpr, SubExpr subexpr
where ifstmt.getCondition() = relop and
  relop.getAnOperand() = addexpr and
  addexpr.getUnspecifiedType() instanceof IntegralType and
  subexpr.getUnspecifiedType() instanceof IntegralType and
  not isFromMacroDefinition(relop) and
  exprMightOverflowPositively(addexpr) and
  (ifstmt.getThen() = exprstmt or
  (ifstmt.getThen() = blockstmt and
  blockstmt.getAStmt() = exprstmt)) and
  exprstmt.getExpr() = assignexpr and
  assignexpr.getRValue() = subexpr and
  ((hashCons(addexpr.getLeftOperand()) = hashCons(assignexpr.getLValue()) and
  globalValueNumber(addexpr.getRightOperand()) = globalValueNumber(subexpr.getRightOperand())) or
  (hashCons(addexpr.getRightOperand()) = hashCons(assignexpr.getLValue()) and
  globalValueNumber(addexpr.getLeftOperand()) = globalValueNumber(subexpr.getRightOperand()))) and
  globalValueNumber(relop.getAnOperand()) = globalValueNumber(subexpr.getLeftOperand()) and
  not globalValueNumber(addexpr.getAnOperand()) = globalValueNumber(relop.getAnOperand())
select ifstmt, "Integer addition may overflow inside if statement."
