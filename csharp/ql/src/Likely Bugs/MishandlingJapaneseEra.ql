/**
 * @name Mishandling the Japanese era start date
 * @description Japanese era should be handled with the built-in 'JapaneseCalendar' class. Avoid hard-coding Japanese era start dates and names.
 * @id cs/mishandling-japanese-era
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @tags reliability
 *       date-time
 */

import csharp

/**
 * Holds if `year`, `month`, and `day` specify the start of a new era
 * (see https://simple.wikipedia.org/wiki/List_of_Japanese_eras).
 */
predicate isEraStart(int year, int month, int day) {
  year = 1989 and month = 1 and day = 8
  or
  year = 2019 and month = 5 and day = 1
}

predicate isExactEraStartDateCreation(ObjectCreation cr) {
  (
    cr.getType().hasQualifiedName("System.DateTime") or
    cr.getType().hasQualifiedName("System.DateTimeOffset")
  ) and
  isEraStart(cr.getArgument(0).getValue().toInt(), cr.getArgument(1).getValue().toInt(),
    cr.getArgument(2).getValue().toInt())
}

predicate isDateFromJapaneseCalendarToDateTime(MethodCall mc) {
  (
    mc.getQualifier().getType().hasQualifiedName("System.Globalization.JapaneseCalendar") or
    mc.getQualifier().getType().hasQualifiedName("System.Globalization.JapaneseLunisolarCalendar")
  ) and
  mc.getTarget().hasName("ToDateTime") and
  mc.getArgument(0).hasValue() and
  (
    mc.getNumberOfArguments() = 7 // implicitly current era
    or
    mc.getNumberOfArguments() = 8 and
    mc.getArgument(7).getValue() = "0"
  ) // explicitly current era
}

predicate isDateFromJapaneseCalendarCreation(ObjectCreation cr) {
  (
    cr.getType().hasQualifiedName("System.DateTime") or
    cr.getType().hasQualifiedName("System.DateTimeOffset")
  ) and
  (
    cr
        .getArgumentForName("calendar")
        .getType()
        .hasQualifiedName("System.Globalization.JapaneseCalendar") or
    cr
        .getArgumentForName("calendar")
        .getType()
        .hasQualifiedName("System.Globalization.JapaneseLunisolarCalendar")
  ) and
  cr.getArgumentForName("year").hasValue()
}

from Expr expr, string message
where
  isDateFromJapaneseCalendarToDateTime(expr) and
  message =
    "'DateTime' created from Japanese calendar with explicit or current era and hard-coded year."
  or
  isDateFromJapaneseCalendarCreation(expr) and
  message =
    "'DateTime' constructed from Japanese calendar with explicit or current era and hard-coded year."
  or
  isExactEraStartDateCreation(expr) and
  message = "Hard-coded the beginning of the Japanese Heisei era."
select expr, message
