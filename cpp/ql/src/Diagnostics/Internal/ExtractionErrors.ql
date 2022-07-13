/**
 * @name Extraction errors
 * @description List all extraction errors for files in the source code directory.
 * @kind diagnostic
 * @id cpp/diagnostics/extraction-errors
 */

import cpp
import ExtractionErrors

// NOTE:
// This file looks like the other `diagnostics/extraction-errors` queries in other CodeQL supported
// languages. However, since this diagnostic query is located in the `Internal` subdirectory it will not
// appear in the Code Scanning suite. The related query `cpp/diagnostics/extraction-warnings` is,
// however, included as a public diagnostics query.
from ExtractionError error
where
  error instanceof ExtractionUnknownError or
  exists(error.getFile().getRelativePath())
select error, "Extraction failed in " + error.getFile() + " with error " + error.getErrorMessage(),
  error.getSeverity()
