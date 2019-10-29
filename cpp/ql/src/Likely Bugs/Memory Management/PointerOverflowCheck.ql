/**
 * @name Dangerous pointer out-of-range check
 * @description Testing for out-of-range pointers by adding a value to a pointer
 *              to see if it "wraps around" is dangerous because it relies
 *              on undefined behavior and may lead to attempted use of
 *              nonexistent or inaccessible memory locations
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/pointer-overflow-check
 * @tags reliability
 *       security
 */

import cpp
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering
private import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from RelationalOperation ro, PointerAddExpr add, Expr expr1, Expr expr2
where
  ro.getAnOperand() = add and
  add.getAnOperand() = expr1 and
  ro.getAnOperand() = expr2 and
  globalValueNumber(expr1) = globalValueNumber(expr2)
select ro, "Pointer out-of-range check relying on pointer overflow is undefined."
