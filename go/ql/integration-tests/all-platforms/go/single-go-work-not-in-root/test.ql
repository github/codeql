import go
import semmle.go.DiagnosticsReporting

from string msg, int sev
where reportableDiagnostics(_, msg, sev)
select msg, sev
