import semmle.code.java.Diagnostics

from Diagnostic d
select d, d.getSeverity(), d.getMessage()
