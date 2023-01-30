/**
 * @name Integer addition may overflow inside if statement
 * @description Detects "if (a+b>c) a=c-b", which is incorrect if a+b overflows.
 *              Should be replaced by "if (a>c-b) a=c-b", which correctly
 *              implements a = min(a,c-b)". This integer overflow is the root
 *              cause of the buffer overflow in the SHA-3 reference implementation
 *              (CVE-2022-37454).
 * @kind problem
 * @problem.severity warning
 * @id cpp/if-statement-addition-overflow
 * @tags: experimental
 *        correctness
 *        security
 *        external/cwe/cwe-190
 */

import cpp

from IfStmt ifstmt, GTExpr gtexpr, ExprStmt exprstmt, AssignExpr assignexpr, AddExpr addexpr, SubExpr subexpr
where ifstmt.getCondition() = gtexpr and
  gtexpr.getLeftOperand() = addexpr and
  ifstmt.getThen() = exprstmt and
  exprstmt.getExpr() = assignexpr and
  assignexpr.getRValue() = subexpr and
  addexpr.getLeftOperand().toString() = assignexpr.getLValue().toString() and
  addexpr.getRightOperand().toString() = subexpr.getRightOperand().toString() and
  gtexpr.getRightOperand().toString() = subexpr.getLeftOperand().toString()
select ifstmt, "Integer addition may overflow inside if statement."
