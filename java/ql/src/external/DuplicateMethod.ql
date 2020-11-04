/**
 * @deprecated
 * @name Duplicate method
 * @description Duplicated methods make code more difficult to understand and introduce a risk of
 *              changes being made to only one copy.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/duplicate-method
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import java
import CodeDuplication

predicate relevant(Method m) {
  m.getNumberOfLinesOfCode() > 5 and not m.getName().matches("get%")
  or
  m.getNumberOfLinesOfCode() > 10
}

from Method m, Method other
where
  duplicateMethod(m, other) and
  relevant(m) and
  not fileLevelDuplication(m.getCompilationUnit(), other.getCompilationUnit()) and
  not classLevelDuplication(m.getDeclaringType(), other.getDeclaringType())
select m, "Method " + m.getName() + " is duplicated in $@.", other,
  other.getDeclaringType().getQualifiedName()
