/**
 * @name Extraction errors msft
 * @description List all extraction errors for files in the source code directory.
 * @id go/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

import go
import semmle.go.DiagnosticsReporting

// Go does not have warnings, so all errors have error severity
predicate reportableDiagnosticsMsft(Diagnostic d, File f, string msg) {
    // Only report errors for files that would have been extracted
    f = d.getFile() and
    exists(f.getAChild()) and
    msg = removeAbsolutePaths(d.getMessage())
  }
  
from Diagnostic d, File f, string msg
where reportableDiagnostics(d, f, msg)
select f, msg
