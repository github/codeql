/**
 * @name Percentage of comments
 * @description The percentage of lines in the code base that contain comments.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       documentation
 * @id cs/comment-ratio-per-file
 */

import csharp

from SourceFile f, int total, float ratio
where
  total = f.getNumberOfLinesOfCode() + f.getNumberOfLinesOfComments() and
  if total = 0
  then ratio = 0.0
  else ratio = 100.0 * f.getNumberOfLinesOfComments().(float) / total.(float)
select f, ratio order by ratio desc
