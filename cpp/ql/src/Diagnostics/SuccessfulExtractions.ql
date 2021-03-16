/**
 * @name Successfully extracted files.
 * @description Lists all files in the database that were extracted without encountering an error.
 * @kind diagnostic
 * @id cpp/diagnostics/successfully-extracted-files
 */

import cpp
import FailedExtractions

from File f
where
  not exists(ExtractionError e | e.getFile() = f) and
  exists(f.getRelativePath())
select f, ""
