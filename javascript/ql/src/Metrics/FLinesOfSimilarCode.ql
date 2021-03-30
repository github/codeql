/**
 * @deprecated
 * @name Similar lines in files
 * @description The number of lines in a file (including code, comment and whitespace lines)
 *              occurring in a block of lines that is similar to a block of lines seen
 *              somewhere else.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id js/similar-lines-in-files
 * @tags testability
 *       duplicate-code
 *       non-attributable
 */

import javascript

from File f, int n
where none()
select f, n order by n desc
