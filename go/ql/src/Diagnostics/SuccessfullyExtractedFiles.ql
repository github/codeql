/**
 * @id go/diagnostics/successfully-extracted-files
 * @name Extracted files
 * @description List all files that were extracted.
 * @kind diagnostic
 * @tags successfully-extracted-files
 */

import go

from File f
where exists(f.getRelativePath())
select f, ""
