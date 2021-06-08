/**
 * @deprecated
 * @name Duplicated lines in files
 * @description The number of lines in a file, including code, comment and whitespace lines,
 *              which are duplicated in at least one other place.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags testability
 * @id py/duplicated-lines-in-files
 */

import python

from File f, int n
where none()
select f, n order by n desc
