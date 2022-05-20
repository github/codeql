/**
 * @name Cyclomatic Complexity
 * @description Functions with high cyclomatic complexity. With increasing cyclomatic complexity there need to be more test cases that are necessary to achieve a complete branch coverage when testing this function.
 * @kind problem
 * @id cpp/architecture/cyclomatic-complexity
 * @problem.severity warning
 * @tags testability
 *       statistical
 *       non-attributable
 */

import cpp

from Function f, int complexity
where
  complexity = f.getMetrics().getCyclomaticComplexity() and
  complexity > 250
select f, "Function has high cyclomatic complexity: " + complexity.toString()
