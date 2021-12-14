/**
 * @name Percentage of documentation in files
 * @description The percentage of comment lines in a file.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg max
 * @id java/comment-ratio-per-file
 * @tags maintainability
 *       documentation
 */

import java

from CompilationUnit f, float comments, float loc, float ratio
where
  f.getTotalNumberOfLines() > 0 and
  comments = f.getNumberOfCommentLines() and
  loc = f.getTotalNumberOfLines() and
  ratio = 100.0 * comments / loc
select f, ratio order by ratio desc
