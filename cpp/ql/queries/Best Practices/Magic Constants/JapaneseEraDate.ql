/**
 * @name Hard-coded Japanese era start date
 * @description Japanese era changes can lead to code behaving differently. Avoid hard-coding Japanese era start dates.
 * @kind problem
 * @problem.severity warning
 * @id cpp/japanese-era/exact-era-date
 * @precision low
 * @tags maintainability
 *       reliability
 *       japanese-era
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

predicate eraDate(int year, int month, int day) {
  year = 1989 and month = 1 and day = 8
  or
  year = 2019 and month = 5 and day = 1
}

predicate badStructInitialization(Element target, string message) {
  exists(
    StructLikeClass s, YearFieldAccess year, MonthFieldAccess month, DayFieldAccess day,
    int yearValue, int monthValue, int dayValue
  |
    eraDate(yearValue, monthValue, dayValue) and
    assignedYear(s, year, yearValue) and
    assignedMonth(s, month, monthValue) and
    assignedDay(s, day, dayValue) and
    target = year and
    message = "A time struct that is initialized with exact Japanese calendar era start date."
  )
}

predicate badCall(Element target, string message) {
  exists(Call cc, int i |
    eraDate(cc.getArgument(i).getValue().toInt(), cc.getArgument(i + 1).getValue().toInt(),
      cc.getArgument(i + 2).getValue().toInt()) and
    target = cc and
    message = "Call that appears to have hard-coded Japanese era start date as parameter."
  )
}

from Element target, string message
where
  badStructInitialization(target, message) or
  badCall(target, message)
select target, message
