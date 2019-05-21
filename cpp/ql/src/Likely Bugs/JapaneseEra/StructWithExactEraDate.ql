/**
 * @name StructWithJapaneseEraStartDate
 * @description Japanese era changes can lead to code behaving differently. Aviod hard-coding Japanese era start dates. The values should be read from registry.
 * @kind problem
 * @problem.severity warning
 * @id cpp/JapaneseEra/Struct-With-Exact-Era-Date
 * @precision medium
 * @tags reliability
 *       japanese-era
 */

import cpp

import semmle.code.cpp.commons.DateTime

from StructLikeClass s, YearFieldAccess year, MonthFieldAccess month, DayFieldAccess day, Operation yearAssignment, Operation monthAssignment, Operation dayAssignment
where s.getAField().getAnAccess () = year and yearAssignment.getAnOperand() = year and yearAssignment.getAnOperand().getValue().toInt() = 1989 and
      s.getAField().getAnAccess () = month and monthAssignment.getAnOperand() = month and monthAssignment.getAnOperand().getValue().toInt() = 1 and 
      s.getAField().getAnAccess () = day and dayAssignment.getAnOperand() = day and dayAssignment.getAnOperand().getValue().toInt() = 8
select year, "A time struct that is initialized with exact Japanese calendar era start date"
