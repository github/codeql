/**
 * @name Long function without assertion
 * @description All functions of more than 10 lines should have at least one assertion.
 * @kind problem
 * @id cpp/jpl-c/use-of-assertions-density
 * @problem.severity recommendation
 * @tags maintainability
 *       reliability
 *       external/jpl
 */

import semmle.code.cpp.commons.Assertions

from Function f
where
  f.getMetrics().getNumberOfLinesOfCode() > 10 and
  not exists(Assertion a | a.getAsserted().getEnclosingFunction() = f)
select f, "All functions of more than 10 lines should have at least one assertion."
