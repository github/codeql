/**
 * @name AV Rule 206
 * @description Allocation/deallocation from/to the free store (heap) shall not
 *              occur after initialization.
 * @kind problem
 * @id cpp/jsf/av-rule-206
 * @problem.severity recommendation
 * @tags resources
 *       external/jsf
 */

import cpp

predicate occursAfterInitialization(Expr e) {
  not e.getEnclosingFunction() instanceof Constructor and
  not e.getEnclosingFunction() instanceof Destructor
}

from Expr e
where isMemoryManagementExpr(e) and occursAfterInitialization(e)
select e, "AV Rule 206: Memory management shall not occur after initialization."
