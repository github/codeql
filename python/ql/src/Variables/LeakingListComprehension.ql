/**
 * @name List comprehension variable used in enclosing scope
 * @description Using the iteration variable of a list comprehension in the enclosing scope will result in different behavior between Python 2 and 3 and is confusing.
 * @kind problem
 * @tags portability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/leaking-list-comprehension
 */

import python
import Definition

from ListComprehensionDeclaration l, Name use, Name defn
where
  use = l.getALeakedVariableUse() and
  defn = l.getDefinition() and
  l.getAFlowNode().strictlyReaches(use.getAFlowNode()) and
  /* Make sure we aren't in a loop, as the variable may be redefined */
  not use.getAFlowNode().strictlyReaches(l.getAFlowNode()) and
  not l.contains(use) and
  not use.deletes(_) and
  not exists(SsaVariable v |
    v.getAUse() = use.getAFlowNode() and
    not v.getDefinition().strictlyDominates(l.getAFlowNode())
  )
select use,
  use.getId() + " may have a different value in Python 3, as the $@ will not be in scope.", defn,
  "list comprehension variable"
