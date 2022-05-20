/**
 * @deprecated
 * @name Duplicated lines in files
 * @description The number of lines in a file, including code, comment and whitespace lines,
 *              which are duplicated in at least one other place.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/duplicated-lines-in-files
 * @tags testability
 *       modularity
 */

import java

from File f, int n
where none()
select f, n order by n desc
