/**
 * @deprecated
 * @name Duplicate method
 * @description There is another identical implementation of this method. Extract the code to a common superclass or delegate to improve sharing.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/duplicate-method
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import csharp
import CodeDuplication

predicate relevant(Method m) {
  m.getNumberOfLinesOfCode() > 5 and not m.getName().matches("get%")
  or
  m.getNumberOfLinesOfCode() > 10
}

pragma[noopt]
predicate query(Method m, Method other) {
  duplicateMethod(m, other) and
  relevant(m) and
  not exists(File f1, File f2 |
    m.getFile() = f1 and fileLevelDuplication(f1, f2) and other.getFile() = f2
  ) and
  not exists(Type t1, Type t2 |
    m.getDeclaringType() = t1 and classLevelDuplication(t1, t2) and other.getDeclaringType() = t2
  )
}

from Method m, Method other
where query(m, other)
select m, "Method " + m.getName() + " is duplicated in $@.", other,
  other.getDeclaringType().getName() + "." + other.getName()
