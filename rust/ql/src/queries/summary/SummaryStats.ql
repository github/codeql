/**
 * @name Summary Statistics
 * @description A table of summary statistics about a database.
 * @kind metric
 * @id rust/summary/summary-statistics
 * @tags summary
 */

import rust
import codeql.rust.Diagnostics
import Stats

from string key, int value
where
  key = "Elements extracted" and value = count(Element e | not e instanceof Unextracted)
  or
  key = "Elements unextracted" and value = count(Unextracted e)
  or
  key = "Extraction errors" and value = count(ExtractionError e)
  or
  key = "Extraction warnings" and value = count(ExtractionWarning w)
  or
  key = "Files extracted - total" and value = count(File f | exists(f.getRelativePath()))
  or
  key = "Files extracted - with errors" and
  value = count(File f | exists(f.getRelativePath()) and not f instanceof SuccessfullyExtractedFile)
  or
  key = "Files extracted - without errors" and
  value = count(SuccessfullyExtractedFile f | exists(f.getRelativePath()))
  or
  key = "Lines of code extracted" and value = getLinesOfCode()
  or
  key = "Lines of user code extracted" and value = getLinesOfUserCode()
  or
  key = "Inconsistencies - AST" and value = getTotalAstInconsistencies()
  or
  key = "Inconsistencies - CFG" and value = getTotalCfgInconsistencies()
  or
  key = "Inconsistencies - data flow" and value = getTotalDataFlowInconsistencies()
select key, value
