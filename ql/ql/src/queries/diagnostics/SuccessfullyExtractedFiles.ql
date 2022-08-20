/**
 * @name Successfully extracted files
 * @description Lists all files in the source code directory that were extracted
 *   without encountering an error in the file.
 * @kind diagnostic
 * @id ql/diagnostics/successfully-extracted-files
 */

import ql
import codeql_ql.Diagnostics

from File f
where
  not exists(ExtractionError e | e.getLocation().getFile() = f) and
  exists(f.getRelativePath())
select f, ""
