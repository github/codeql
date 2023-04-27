/**
 * @name Type inference fails for 'object'
 * @description Type inference fails for 'object' which reduces recall for many queries.
 * @kind problem
 * @problem.severity info
 * @id py/type-inference-failure
 * @deprecated
 */

import python

from ControlFlowNode f, Object o
where
  f.refersTo(o) and
  not f.refersTo(o, _, _)
select o, "Type inference fails for 'object'."
