/**
 * @deprecated
 * @name Mostly duplicate method
 * @description Methods in which most of the lines are duplicated in another method make code more
 *              difficult to understand and introduce a risk of changes being made to only one copy.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/similar-method
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import java
import CodeDuplication

from Method m, int covered, int total, Method other, int percent
where
  duplicateStatements(m, other, covered, total) and
  covered != total and
  m.getMetrics().getNumberOfLinesOfCode() > 5 and
  covered * 100 / total = percent and
  percent > 80 and
  not duplicateMethod(m, other) and
  not classLevelDuplication(m.getDeclaringType(), other.getDeclaringType()) and
  not fileLevelDuplication(m.getCompilationUnit(), other.getCompilationUnit())
select m, percent + "% of the statements in " + m.getName() + " are duplicated in $@.", other,
  other.getDeclaringType().getName() + "." + other.getStringSignature()
