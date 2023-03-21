/**
 * @id go/diagnostics/extraction-errors
 * @name Extraction errors
 * @description List all extraction errors for files in the source code directory.
 * @kind diagnostic
 */

import go
import semmle.go.DiagnosticsReporting

from string msg, int sev
where reportableDiagnostics(_, msg, sev)
select msg, sev
