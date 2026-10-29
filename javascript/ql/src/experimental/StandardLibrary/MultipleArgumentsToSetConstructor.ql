/**
 * @name Multiple arguments to `Set` constructor
 * @description The `Set` constructor ignores all but the first argument, so passing multiple
 *              arguments may indicate a mistake.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/multiple-arguments-to-set-constructor
 * @tags correctness
 */

import javascript

from DataFlow::NewNode newSet, DataFlow::Node ignoredArg
where
  newSet = DataFlow::globalVarRef("Set").getAnInstantiation() and
  (
    ignoredArg = newSet.getArgument(any(int n | n > 0))
    or
    ignoredArg = newSet.getASpreadArgument()
  )
select ignoredArg, "All but the first argument to the Set constructor are ignored."
