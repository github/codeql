/**
 * @name Extraction errors
 * @description List all extraction errors for files in the source code directory.
 * @kind diagnostic
 * @id rust/diagnostics/extraction-errors
 */

import codeql.rust.Diagnostics
import codeql.files.FileSystem

/** Gets the SARIF severity to associate with an error. */
int getSeverity() { result = 2 }

from ExtractionError error, ExtractedFile f
where
  f = error.getLocation().getFile() and
  exists(f.getRelativePath())
select error, "Extraction failed in " + f + " with error " + error.getMessage(), getSeverity()
