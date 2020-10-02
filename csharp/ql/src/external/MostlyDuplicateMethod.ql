/**
 * @deprecated
 * @name Mostly duplicate method
 * @description There is another method that shares a lot of the code with this method. Extract the code to a common superclass or delegate to improve sharing.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/similar-method
 * @tags testability
 *       maintainability
 *       useless-code
 *       statistical
 *       non-attributable
 */

import csharp
import CodeDuplication

from Method m, int covered, int total, Method other, int percent
where
  duplicateStatements(m, other, covered, total) and
  covered != total and
  m.getNumberOfLinesOfCode() > 5 and
  covered * 100 / total = percent and
  percent > 80 and
  not duplicateMethod(m, other) and
  not classLevelDuplication(m.getDeclaringType(), other.getDeclaringType()) and
  not fileLevelDuplication(m.getFile(), other.getFile())
select m, percent + "% of the statements in " + m.getName() + " are duplicated in $@.", other,
  other.getDeclaringType().getName() + "." + other.getName()
