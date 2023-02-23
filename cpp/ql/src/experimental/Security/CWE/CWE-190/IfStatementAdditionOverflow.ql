/**
 * @name Integer addition may overflow inside if statement
 * @description "if (a+b>c) a=c-b" was detected where "a+b" may potentially
 *              produce an integer overflow (or wraparound). The code can be
 *              rewritten to "if (a>c-b) a=c-b" which avoids the overflow.
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
  globalValueNumber(relop.getAnOperand()) = globalValueNumber(subexpr.getLeftOperand())
select ifstmt, "Integer addition may overflow inside if statement."
