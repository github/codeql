/**
 * @name Lines of comments in files
 * @description Measures the number of lines which contain a comment
 *              or part of a comment (that is, which are part of a
 *              multi-line comment).
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id cpp/lines-of-comments-in-files
 * @tags maintainability
 *       documentation
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLinesOfComments() as n order by n desc
