/**
 * @name Poorly documented large function
 * @description Large functions that have no or almost no comments are likely to be too complex to understand and maintain. The larger a function is, the more problematic the lack of comments.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/poorly-documented-function
 * @tags maintainability
 *       documentation
 *       statistical
 *       non-attributable
 */

import cpp

from MetricFunction f, int n
where
  n = f.getNumberOfLines() and
  n > 100 and
  f.getCommentRatio() <= 0.02 and
  not f.isMultiplyDefined()
select f,
  "Poorly documented function: fewer than 2% comments for a function of " + n.toString() + " lines."
