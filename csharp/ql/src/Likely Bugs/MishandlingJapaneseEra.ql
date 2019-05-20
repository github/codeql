/**
 * @name MishandlingJapaneseEraStartDate
 * @description Japanese Era should be handled with built-in JapaneseCalendar class. Aviod hard-coding Japanese era start dates and names. 
 * @id cs/mishandling-japanese-era
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @tags reliability
 *       japanese-era
 */

import csharp

predicate isExactEraStartDateCreation(ObjectCreation cr) {
  (cr.getType().hasQualifiedName("System.DateTime") or cr.getType().hasQualifiedName("System.DateTimeOffset"))
  and  
    cr.getArgument(0).getValue() = "1989" and
    cr.getArgument(1).getValue() = "1" and
    cr.getArgument(2).getValue() = "8"
}

predicate isDateFromJapaneseCalendarToDateTime(MethodCall mc) {
  (mc.getQualifier().getType().hasQualifiedName("System.Globalization.JapaneseCalendar") or mc.getQualifier().getType().hasQualifiedName("System.Globalization.JapaneseLunisolarCalendar"))
  and 
    mc.getTarget().hasName("ToDateTime") and
    mc.getArgument(0).getValue() != "" and
    (mc.getNumberOfArguments() = 7 or // implicitly current era
     mc.getNumberOfArguments() = 8 and
     mc.getArgument(7).getValue() = "0") // explicitly current era
}

predicate isDateFromJapaneseCalendarCreation(ObjectCreation cr) {
  (cr.getType().hasQualifiedName("System.DateTime") or cr.getType().hasQualifiedName("System.DateTimeOffset")) and
  (cr.getArgumentForName("calendar").getType().hasQualifiedName("System.Globalization.JapaneseCalendar") or cr.getArgumentForName("calendar").getType().hasQualifiedName("System.Globalization.JapaneseLunisolarCalendar"))
  and  
    cr.getArgumentForName("year").getValue() != ""
}

predicate inEraArrayCreation(ArrayInitializer ai) {
  ai.getElement(0).getValue() = "1867" and
  ai.getElement(1).getValue() = "1911" and
  ai.getElement(2).getValue() = "1925" and
  ai.getElement(3).getValue() = "1988"
}

predicate isEraCollectionCreation(CollectionInitializer cs) {
  cs.getElementInitializer(0).getValue() = "1867" and
  cs.getElementInitializer(1).getValue() = "1911" and
  cs.getElementInitializer(2).getValue() = "1925" and
  cs.getElementInitializer(3).getValue() = "1988"	
}

from Expr expr, string message
where 
  isDateFromJapaneseCalendarToDateTime(expr) and message = "DateTime created from Japanese calendar with explicit or current era and hard-coded year" or
  isDateFromJapaneseCalendarCreation(expr) and message = "DateTime constructed from Japanese calendar with explicit or current era and hard-coded year" or
  isEraCollectionCreation(expr) and message = "Hard-coded collection with Japanese era years" or
  inEraArrayCreation (expr) and message = "Hard-coded array with Japanese era years" or
  isExactEraStartDateCreation(expr) and message = "Hard-coded the beginning of the Japanese Heisei era"  
select expr, message
