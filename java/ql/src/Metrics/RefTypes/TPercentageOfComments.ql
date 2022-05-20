/**
 * @name Percentage of documentation in types
 * @description The percentage of a type's lines that are comment rather than code.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/documentation-ratio-per-type
 * @tags maintainability
 *       documentation
 */

import java

from RefType t, int n
where
  t.fromSource() and
  n =
    (100 * t.getMetrics().getNumberOfCommentLines()) /
      (t.getMetrics().getNumberOfCommentLines() + t.getMetrics().getNumberOfLinesOfCode())
select t, n order by n desc
