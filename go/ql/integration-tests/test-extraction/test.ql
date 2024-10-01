import go
import semmle.go.DiagnosticsReporting

from GoFile f
select f

query predicate calls(CallExpr ce, FuncDecl f) { f = ce.getTarget().getFuncDecl() }

query predicate extractionErrors(string msg, int sev) { reportableDiagnostics(_, msg, sev) }
