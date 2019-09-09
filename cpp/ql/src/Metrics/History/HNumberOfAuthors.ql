/**
 * @name Number of authors
 * @description Number of distinct authors for each file.
 * @kind treemap
 * @id cpp/historical-number-of-authors
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 * @tags external-data
 * @deprecated
 */

import cpp
import external.VCS

from File f
where exists(f.getMetrics().getNumberOfLinesOfCode())
select f, count(Author author | author.getAnEditedFile() = f)
