/**
 * @deprecated
 * @name Duplicate function
 * @description There is another identical implementation of this function. Extract the code to a common file or superclass or delegate to improve sharing.
 * @kind problem
 * @id cpp/duplicate-function
 * @problem.severity recommendation
 * @precision medium
 * @tags testability
 *       maintainability
 *       duplicate-code
 *       non-attributable
 */

import cpp
import CodeDuplication

predicate relevant(FunctionDeclarationEntry m) {
  exists(Location loc |
    loc = m.getBlock().getLocation() and
    (
      loc.getStartLine() + 5 < loc.getEndLine() and not m.getName().matches("get%")
      or
      loc.getStartLine() + 10 < loc.getEndLine()
    )
  )
}

from FunctionDeclarationEntry m, FunctionDeclarationEntry other
where
  duplicateMethod(m, other) and
  relevant(m) and
  not m.getFunction().isConstructedFrom(_) and
  not other.getFunction().isConstructedFrom(_) and
  not fileLevelDuplication(m.getFile(), other.getFile()) and
  not classLevelDuplication(m.getFunction().getDeclaringType(),
    other.getFunction().getDeclaringType())
select m, "Function " + m.getName() + " is duplicated at $@.", other,
  other.getFile().getBaseName() + ":" + other.getLocation().getStartLine().toString()
