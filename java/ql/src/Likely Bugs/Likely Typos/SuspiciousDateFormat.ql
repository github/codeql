/**
 * @name Suspicious date format
 * @description Some date format patterns don't work as they might seem.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/suspicious-date-format
 * @tags correctness
 */

import java

from ConstructorCall c, string format
where
  c.getConstructedType().hasQualifiedName("java.text", "SimpleDateFormat") and
  format = c.getArgument(0).(StringLiteral).getValue() and
  format.matches("%Y%") and
  format.matches("%M%")
select c, "Date formatter is passed a suspicious pattern \"" + format + "\"."
