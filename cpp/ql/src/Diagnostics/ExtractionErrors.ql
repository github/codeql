/**
 * @name Extraction errors
 * @description List all extraction errors for files in the source code directory.
 * @kind diagnostic
 * @id cpp/diagnostics/extraction-errors
 */

import cpp
import ExtractionErrors

from ExtractionError error
where
  error instanceof ExtractionUnknownError or
  exists(error.getFile().getRelativePath())
select error, "Extraction failed in " + error.getFile() + " with error " + error.getErrorMessage(),
  error.getSeverity()
