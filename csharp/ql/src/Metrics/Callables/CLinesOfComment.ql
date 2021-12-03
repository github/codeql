/**
 * @name Lines of comment per method
 * @description Methods with few lines of comment might not have sufficient documentation to make them understandable.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 *       documentation
 * @id cs/lines-of-comment-per-function
 */

import csharp

from Callable c
where c.isSourceDeclaration()
select c, c.getNumberOfLinesOfComments() as n order by n desc
