/**
 * @name Extraction error
 * @description An error message reported by the extractor, limited to those files where there are no
 *              compilation errors. This indicates a bug or limitation in the extractor, and could lead
 *              to inaccurate results.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/extraction-error
 * @tags internal non-attributable
 */

import csharp
import semmle.code.csharp.commons.Diagnostics

from ExtractorError error
where not exists(CompilerError ce | ce.getLocation().getFile() = error.getLocation().getFile())
select error,
  "Unexpected " + error.getOrigin() + " error: " + error.getText() + "\n" + error.getStackTrace()
