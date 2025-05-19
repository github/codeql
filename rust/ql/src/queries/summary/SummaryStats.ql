/**
 * @name Summary Statistics
 * @description A table of summary statistics about a database.
 * @kind metric
 * @id rust/summary/summary-statistics
 * @tags summary
 */

import rust
import Stats

from string key, int value
where
  elementStats(key, value)
  or
  extractionStats(key, value)
  or
  inconsistencyStats(key, value)
  or
  taintStats(key, value)
select key, value order by key
