/**
 * @name Percentage of comments
 * @description The percentage of lines that contain comments.
 * @kind treemap
 * @id cpp/comment-ratio-per-file
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       documentation
 */

import cpp

from File f, int comments, int total
where f.fromSource() and numlines(unresolveElement(f), total, _, comments) and total > 0
select f, 100.0 * (comments.(float) / total.(float)) as ratio order by ratio desc
