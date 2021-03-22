/**
 * @name Successfully extracted files
 * @description Lists all files in the source code directory that were extracted without encountering an error in the file.
 * @kind diagnostic
 * @id cpp/diagnostics/successfully-extracted-files
 */

import cpp
import ExtractionErrors

from File f
where
  not exists(ExtractionError e | e.getFile() = f) and
  exists(f.getRelativePath())
select f, ""
