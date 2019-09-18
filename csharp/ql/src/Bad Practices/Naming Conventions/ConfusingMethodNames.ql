/**
 * @name Confusing method names because of capitalization
 * @description Finds methods whose name only differs in capitalization from another method defined in the same class.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/confusing-method-name
 * @tags maintainability
 *       readability
 *       naming
 */

import csharp

predicate typeWithConfusingName(ValueOrRefType type) {
  strictcount(type.getAMethod().getName()) != strictcount(type.getAMethod().getName().toLowerCase())
}

from Method m, Method n, ValueOrRefType type
where
  typeWithConfusingName(type) and
  type.fromSource() and
  m = type.getAMethod() and
  n = type.getAMethod() and
  m != n and
  m.getName().toLowerCase() = n.getName().toLowerCase() and
  m.getName() < n.getName()
select m, "Confusing method name, compare with $@.", n, n.getName()
