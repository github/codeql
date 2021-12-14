/**
 * @deprecated
 * @name Mostly duplicate function
 * @description There is another function that shares a lot of the code with this one. Extract the code to a common file/superclass or delegate to improve sharing.
 * @kind problem
 * @id cpp/mostly-duplicate-function
 * @problem.severity recommendation
 * @precision medium
 * @tags testability
 *       duplicate-code
 *       non-attributable
 */

import cpp
import CodeDuplication

from FunctionDeclarationEntry m, int covered, int total, FunctionDeclarationEntry other, int percent
where
  duplicateStatements(m, other, covered, total) and
  covered != total and
  total > 5 and
  covered * 100 / total = percent and
  percent > 80 and
  not m.getFunction().isConstructedFrom(_) and
  not other.getFunction().isConstructedFrom(_) and
  not duplicateMethod(m, other) and
  not classLevelDuplication(m.getFunction().getDeclaringType(),
    other.getFunction().getDeclaringType()) and
  not fileLevelDuplication(m.getFile(), other.getFile())
select m, percent + "% of the statements in " + m.getName() + " are duplicated in $@.", other,
  other.getFunction().getQualifiedName()
