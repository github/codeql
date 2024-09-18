/**
 * @name Summary Statistics
 * @description A table of summary statistics about a database.
 * @kind table
 * @id rust/summary/summary-statistics
 * @tags summary
 */

import rust
import Stats

from string key, string value
where
  key = "Files extracted" and value = count(File f | exists(f.getRelativePath())).toString()
  or
  key = "Elements extracted" and value = count(Element e | not e instanceof Unextracted).toString()
  or
  key = "Elements unextracted" and value = count(Unextracted e).toString()
  or
  key = "Lines of code extracted" and value = getLinesOfCode().toString()
  or
  key = "Lines of user code extracted" and value = getLinesOfUserCode().toString()
select key, value
