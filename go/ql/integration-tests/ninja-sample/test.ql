import go
import semmle.go.DiagnosticsReporting

from GoFile f
select f

query predicate htmlFiles(HtmlFile x) { any() }

query predicate extractionErrors(string msg, int sev) { reportableDiagnostics(_, msg, sev) }
