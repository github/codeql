/**
 * @name Successfully extracted files
 * @description Lists all files that were extracted without encountering an
 *   error in the file.
 * @kind diagnostic
 * @id rb/diagnostics/successfully-extracted-files
 */

import ruby
import codeql_ruby.Diagnostics

from File f
where not exists(ExtractionError e | e.getLocation().getFile() = f)
select f, ""
