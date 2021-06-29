/**
 * @name Successfully extracted files
 * @description A list of all files in the source code directory that were extracted
 *              without encountering an extraction or compiler error in the file.
 * @kind diagnostic
 * @id cs/diagnostics/successfully-extracted-files
 */

import csharp
import semmle.code.csharp.commons.Diagnostics

from File file
where
  file.fromSource() and
  not exists(ExtractorError e | e.getLocation().getFile() = file) and
  not exists(CompilerError e | e.getLocation().getFile() = file)
select file, ""
