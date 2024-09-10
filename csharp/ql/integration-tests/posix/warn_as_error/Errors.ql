import csharp
import semmle.code.csharp.commons.Diagnostics

from Diagnostic d
where d.getSeverity() >= 3
select d
