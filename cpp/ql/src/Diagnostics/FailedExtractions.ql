/**
 * @name Failed extractions
 * @description List all files in the source code directory with extraction errors.
 * @kind diagnostic
 * @id cpp/diagnostics/failed-extractions
 */

import cpp
import FailedExtractions

from ExtractionError error
where
  error instanceof ExtractionUnknownError or
  exists(error.getFile().getRelativePath())
select error, "Extracting failed in " + error.getFile() + " with error " + error.getErrorMessage(),
  error.getSeverity()
