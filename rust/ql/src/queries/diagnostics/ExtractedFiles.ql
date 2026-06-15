/**
 * @name Extracted files
 * @description Lists all files in the source code directory that were extracted.
 * @kind diagnostic
 * @id rust/diagnostics/successfully-extracted-files
 * @tags successfully-extracted-files
 */

import rust

from ExtractedFile f
where exists(f.getRelativePath())
select f, "File successfully extracted."
