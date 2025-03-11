/**
 * @name Summary Statistics Less
 * @description A table of summary statistics about a database, with data that
 *              has been found to be noisy on tests removed.
 * @kind metric
 * @id rust/summary/summary-statistics-less
 * @tags summary
 */

import rust
import Stats

from string key, int value
where
  extractionStats(key, value)
  or
  inconsistencyStats(key, value)
select key, value order by key
