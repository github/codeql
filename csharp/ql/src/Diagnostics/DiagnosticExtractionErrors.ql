/**
 * @name Extraction errors
 * @description List all errors reported by the extractor. The returned issues are
 *              limited to those files where there are no compilation errors. This
 *              indicates a bug or limitation in the extractor, and could lead to
 *              inaccurate results.
 * @kind diagnostic
 * @id cs/diagnostics/extraction-errors
 */

import csharp
import semmle.code.csharp.commons.Diagnostics

from ExtractorError error
where not exists(CompilerError ce | ce.getLocation().getFile() = error.getLocation().getFile())
select error,
  "Unexpected " + error.getOrigin() + " error: " + error.getText() + " in " +
    error.getLocation().getFile(), 3
