/**
 * @name Files extracted with errors
 * @description Lists files that were extracted, but may be incomplete due to
 *   extraction errors.
 * @kind diagnostic
 * @id rb/diagnostics/files-extracted-with-errors
 */

import ruby
import codeql_ruby.Diagnostics

from File f
where exists(ExtractionError e | e.getLocation().getFile() = f)
select f, ""
