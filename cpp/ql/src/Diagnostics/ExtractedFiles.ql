/**
 * @name Extracted files
 * @description Lists all files in the source code directory that were extracted.
 * @kind diagnostic
 * @id cpp/diagnostics/successfully-extracted-files
 * @tags successfully-extracted-files
 */

import cpp

from File f
where exists(f.getRelativePath()) and f.fromSource()
select f, "File successfully extracted."
