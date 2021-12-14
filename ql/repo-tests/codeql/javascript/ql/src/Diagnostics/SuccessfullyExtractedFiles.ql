/**
 * @name Successfully extracted files
 * @description Lists all files in the source code directory that were extracted without encountering an error in the file.
 * @kind diagnostic
 * @id js/diagnostics/successfully-extracted-files
 */

import javascript

from File f
where
  not exists(Error e | e.isFatal() and e.getFile() = f) and
  exists(f.getRelativePath())
select f, ""
