/**
 * @name Number of lines
 * @description The number of lines in each file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id cs/lines-per-file
 */

import csharp

from SourceFile f
select f, f.getNumberOfLines() as n order by n desc
