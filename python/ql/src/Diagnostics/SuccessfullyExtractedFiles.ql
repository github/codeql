/**
 * @name Successfully extracted Python files
 * @description Lists all Python files in the source code directory that were extracted
 *   without encountering an error.
 * @kind diagnostic
 * @id py/diagnostics/successfully-extracted-files
 */

import python

from File file
where
  not exists(SyntaxError e | e.getFile() = file) and
  exists(file.getRelativePath())
select file, ""
