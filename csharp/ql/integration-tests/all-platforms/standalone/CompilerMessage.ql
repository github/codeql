import csharp
import semmle.code.csharp.commons.Diagnostics

from Diagnostic diagnostic
select diagnostic,
  diagnostic.getSeverityText() + " " + diagnostic.getTag() + " " + diagnostic.getFullMessage()
