import go
import semmle.go.DiagnosticsReporting

query predicate extractedFiles(File f) { any() }

from string msg, int sev
where reportableDiagnostics(_, msg, sev)
select msg, sev
