/**
 * @name Check all non-scope nodes have an immediate dominator
 * @description Check all non-scope nodes have an immediate dominator
 * @kind table
 * @problem.severity warning
 */

import python

/* This query should *never* produce a result */
from ControlFlowNode f
where
  not exists(f.getImmediateDominator()) and
  not f.getNode() instanceof Scope
select f
