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
  key = "Lines of code" and value = getLinesOfCode().toString()
  or
  key = "Lines of user code" and value = getLinesOfUserCode().toString()
select key, value
