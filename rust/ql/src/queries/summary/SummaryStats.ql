/**
 * @name Summary Statistics
 * @description A table of summary statistics about a database.
 * @kind table
 * @id rust/summary/summary-statistics
 * @tags summary
 */

import rust
import codeql.rust.Diagnostics
import Stats

from string key, string value
where
  key = "Elements extracted" and value = count(Element e | not e instanceof Unextracted).toString()
  or
  key = "Elements unextracted" and value = count(Unextracted e).toString()
  or
  key = "Extraction errors" and value = count(ExtractionError e).toString()
  or
  key = "Extraction warnings" and value = count(ExtractionWarning w).toString()
  or
  key = "Files extracted - total" and value = count(File f | exists(f.getRelativePath())).toString()
  or
  key = "Files extracted - with errors" and
  value =
    count(File f | exists(f.getRelativePath()) and not f instanceof SuccessfullyExtractedFile)
        .toString()
  or
  key = "Files extracted - without errors" and
  value = count(SuccessfullyExtractedFile f | exists(f.getRelativePath())).toString()
  or
  key = "Lines of code extracted" and value = getLinesOfCode().toString()
  or
  key = "Lines of user code extracted" and value = getLinesOfUserCode().toString()
select key, value
