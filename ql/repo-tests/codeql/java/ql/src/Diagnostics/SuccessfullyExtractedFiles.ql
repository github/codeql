/**
 * @name Successfully extracted files
 * @description A list of all files in the source code directory that
 *              were extracted without encountering an error in the file.
 * @kind diagnostic
 * @id java/diagnostics/successfully-extracted-files
 */

import java
import DiagnosticsReporting

from CompilationUnit f
where successfullyExtracted(f)
select f, ""
