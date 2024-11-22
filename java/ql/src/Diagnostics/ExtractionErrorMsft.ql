/**
 * @name Extraction errors msft
 * @description A list of extraction errors for files in the source code directory.
 * @id java/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

import java
import DiagnosticsReporting

private predicate knownErrorsMsft(Diagnostic d, File f, string msg) {
      d.getSeverity() = [6, 7, 8] and
      f = d.getLocation().getFile()
      msg = d.getMessage()
  }
  
  private predicate unknownErrorsMsft(Diagnostic d, File f, string msg) {
    not knownErrors(d, _, _) and
    d.getSeverity() > 3 and
    d.getLocation().getFile() = f and
    exists(f.getRelativePath()) and
    msg = "Unknown error"
  }

from Diagnostic d, File f, string msg
where
    knownErrorsMsft(Diagnostic d, File f, string msg) or
    unknownErrorsMsft(Diagnostic d, File f, string msg)
select f, msg
