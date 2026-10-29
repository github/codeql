/**
 * @name Extracted files
 * @description Lists all files in the source code directory that were extracted.
 * @kind diagnostic
 * @id js/diagnostics/successfully-extracted-files
 * @tags successfully-extracted-files
 */

import javascript

from File f
where exists(f.getRelativePath())
select f, ""
