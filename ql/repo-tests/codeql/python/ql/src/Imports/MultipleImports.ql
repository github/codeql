/**
 * @name Module is imported more than once
 * @description Importing a module a second time has no effect and impairs readability
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/repeated-import
 */

import python

predicate is_simple_import(Import imp) { not exists(Attribute a | imp.contains(a)) }

predicate double_import(Import original, Import duplicate, Module m) {
  original != duplicate and
  is_simple_import(original) and
  is_simple_import(duplicate) and
  /* Imports import the same thing */
  exists(ImportExpr e1, ImportExpr e2 |
    e1.getName() = m.getName() and
    e2.getName() = m.getName() and
    e1 = original.getAName().getValue() and
    e2 = duplicate.getAName().getValue()
  ) and
  original.getAName().getAsname().(Name).getId() = duplicate.getAName().getAsname().(Name).getId() and
  exists(Module enclosing |
    original.getScope() = enclosing and
    duplicate.getEnclosingModule() = enclosing and
    (
      /* Duplicate is not at top level scope */
      duplicate.getScope() != enclosing
      or
      /* Original dominates duplicate */
      original.getAnEntryNode().dominates(duplicate.getAnEntryNode())
    )
  )
}

from Import original, Import duplicate, Module m
where double_import(original, duplicate, m)
select duplicate,
  "This import of module " + m.getName() + " is redundant, as it was previously imported $@.",
  original, "on line " + original.getLocation().getStartLine().toString()
