/**
 * @name Comment ratio per function
 * @description Methods where a small percentage of the lines are commented might not have sufficient documentation to make them understandable.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType callable
 * @metricAggregate avg max
 * @tags maintainability
 *       documentation
 * @id cs/comment-ratio-per-type
 */

import csharp

from Callable f, int loc
where f.isSourceDeclaration() and loc = f.getNumberOfLines() and loc > 0
select f, 100.0 * (f.getNumberOfLinesOfComments().(float) / loc.(float))
