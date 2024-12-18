/**
 * @name Extracted files
 * @description A list of all files in the source code directory that
 *              were extracted.
 * @kind diagnostic
 * @id java/diagnostics/successfully-extracted-files
 * @tags successfully-extracted-files
 */

import java
import DiagnosticsReporting

from CompilationUnit f
where extracted(f)
select f, ""
