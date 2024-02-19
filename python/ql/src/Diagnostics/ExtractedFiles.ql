/**
 * @name Extracted Python files
 * @description Lists all Python files in the source code directory that were extracted.
 * @kind diagnostic
 * @id py/diagnostics/successfully-extracted-files
 * @tags successfully-extracted-files
 */

import python

from File file
where exists(file.getRelativePath())
select file, ""
