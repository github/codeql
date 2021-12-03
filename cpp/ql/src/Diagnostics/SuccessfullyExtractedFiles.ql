/**
 * @name Successfully extracted files
 * @description Lists all files in the source code directory that were extracted without encountering a problem in the file.
 * @kind diagnostic
 * @id cpp/diagnostics/successfully-extracted-files
 */

import cpp
import ExtractionProblems

from File f
where
  not exists(ExtractionProblem e | e.getFile() = f) and
  exists(f.getRelativePath())
select f, "File successfully extracted"
