/**
 * @id go/diagnostics/successfully-extracted-files
 * @name Successfully analyzed files
 * @description List all files that were successfully extracted.
 * @kind diagnostic
 * @tags successfully-extracted-files
 */

import go

from File f
where
  not exists(Error e | e.getFile() = f) and
  exists(f.getRelativePath())
select f, ""
