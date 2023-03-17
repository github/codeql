/**
 * @name Successfully extracted files
 * @description Lists all files in the source code directory that were extracted without encountering a problem in the file.
 * @kind diagnostic
 * @id swift/diagnostics/successfully-extracted-files
 * @tags successfully-extracted-files
 */

import swift

from File f
where
  not exists(CompilerError e | e.getFile() = f) and
  f.getBaseName().regexpMatch(".*\\.swift\\z")
select f, "File successfully extracted."
