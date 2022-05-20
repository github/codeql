/**
 * @name Number of authors
 * @description Number of distinct authors for each file
 * @kind treemap
 * @id py/historical-number-of-authors
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 */

import python
import external.VCS

from Module m
where exists(m.getMetrics().getNumberOfLinesOfCode())
select m, count(Author author | author.getAnEditedFile() = m.getFile())
