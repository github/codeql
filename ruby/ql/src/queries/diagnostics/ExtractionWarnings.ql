/**
 * @name Extraction warnings
 * @description List all extraction warnings for files in the source code directory.
 * @kind diagnostic
 * @id rb/diagnostics/extraction-warnings
 */

import codeql.ruby.AST
import codeql.ruby.Diagnostics

/** Gets the SARIF severity to associate with a warning. */
int getSeverity() { result = 1 }

from ExtractionWarning warning, File f
where
  f = warning.getLocation().getFile() and
  exists(f.getRelativePath())
select warning, "Extraction warning in " + f + " with message " + warning.getMessage(),
  getSeverity()
