/**
 * @name Lines of user code in files
 * @description Measures the number of lines of code in each file from the source directory, ignoring lines that contain only comments or whitespace.
 * @kind metric
 * @id rust/summary/lines-of-user-code-in-files
 * @metricType file
 */

import rust

from File f, int n
where
  exists(f.getRelativePath()) and
  n = f.getNumberOfLinesOfCode()
select f, n order by n desc
