/**
 * @id go/summary/successfully-extracted-files
 * @name Successfully analyzed files
 * @description List all files that were successfully extracted.
 * @kind diagnostic
 */

import go

from File f
where not exists(Error e | e.getFile() = f)
select f.getRelativePath()
