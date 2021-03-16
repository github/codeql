/**
 * @name Failed extractions
 * @description Gives the command-line of compilations for which extraction did not run to completion.
 * @kind diagnostic
 * @id cpp/diagnostics/failed-extractions
 */

import cpp
import FailedExtractions

from ExtractionError error
where
  error instanceof ExtractionUnknownError or
  exists(error.getFile().getRelativePath())
select error, "Extracting file $@ failed with $@ (at $@)", error.getFile(), error.getErrorMessage(),
  error.getLocation(), error.getSeverity()
