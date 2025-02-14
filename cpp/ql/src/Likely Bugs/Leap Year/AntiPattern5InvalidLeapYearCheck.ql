/**
 * @name Leap Year Invalid Check (AntiPattern 5)
 * @description An expression is used to check a year is presumably a leap year, but the conditions used are insufficient.
 * @kind problem
 * @problem.severity warning
 * @id cpp/microsoft/public/leap-year/invalid-leap-year-check
 * @precision medium
 * @tags leap-year
 *       correctness
 */

import cpp
import LeapYear

from Mod4CheckedExpr exprMod4
where not exists(ExprCheckLeapYear lyCheck | lyCheck.getAChild*() = exprMod4)
select exprMod4, "Possible Insufficient Leap Year check (AntiPattern 5)"
