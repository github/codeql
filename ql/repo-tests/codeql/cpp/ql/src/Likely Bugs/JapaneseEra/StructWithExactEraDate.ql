/**
 * @name Hard-coded Japanese era start date in struct
 * @description Japanese era changes can lead to code behaving differently. Avoid hard-coding Japanese era start dates.
 * @kind problem
 * @problem.severity warning
 * @id cpp/japanese-era/struct-with-exact-era-date
 * @precision medium
 * @tags reliability
 *       japanese-era
 * @deprecated This query is deprecated, use
 *             Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`)
 *             instead.
 */

import cpp
import semmle.code.cpp.commons.DateTime

predicate assignedYear(Struct s, YearFieldAccess year, int value) {
  exists(Operation yearAssignment |
    s.getAField().getAnAccess() = year and
    yearAssignment.getAnOperand() = year and
    yearAssignment.getAnOperand().getValue().toInt() = value
  )
}

predicate assignedMonth(Struct s, MonthFieldAccess month, int value) {
  exists(Operation monthAssignment |
    s.getAField().getAnAccess() = month and
    monthAssignment.getAnOperand() = month and
    monthAssignment.getAnOperand().getValue().toInt() = value
  )
}

predicate assignedDay(Struct s, DayFieldAccess day, int value) {
  exists(Operation dayAssignment |
    s.getAField().getAnAccess() = day and
    dayAssignment.getAnOperand() = day and
    dayAssignment.getAnOperand().getValue().toInt() = value
  )
}

from StructLikeClass s, YearFieldAccess year, MonthFieldAccess month, DayFieldAccess day
where
  assignedYear(s, year, 1989) and
  assignedMonth(s, month, 1) and
  assignedDay(s, day, 8)
select year, "A time struct that is initialized with exact Japanese calendar era start date."
