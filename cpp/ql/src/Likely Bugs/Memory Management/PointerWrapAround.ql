/**
 * @name Reliance on pointer wrap-around
 * @description Testing for out-of-range pointers by adding a value to a pointer
 *              to see if it "wraps around" is dangerous because it relies
 *              on undefined behavior and may lead to attempted use of
 *              nonexistent or inaccessible memory locations.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/pointer-overflow-check
 * @tags reliability
 *       security
 */

import cpp
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering

class AssertMacro extends Macro {
  AssertMacro() {
    getName() = "assert" or
    getName() = "_ASSERT" or
    getName() = "_ASSERTE" or
    getName() = "_ASSERT_EXPR"
  }
}

from RelationalOperation ro, PointerAddExpr add, Expr expr1, Expr expr2
where
  ro.getAnOperand() = add and
  add.getAnOperand() = expr1 and
  ro.getAnOperand() = expr2 and
  globalValueNumber(expr1) = globalValueNumber(expr2) and
  not exists(MacroInvocation mi |
    mi.getAnAffectedElement() = add and not mi.getMacro() instanceof AssertMacro
  )
select ro, "Pointer out-of-range check relying on pointer overflow is undefined."
