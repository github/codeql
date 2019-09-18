/**
 * @name Iteration using non-local variable
 * @description For-in/for-of loops whose iteration variable is not a purely local variable may
 *              prevent optimization of the surrounding function.
 * @kind problem
 * @problem.severity warning
 * @id js/iteration-using-non-local-variable
 * @tags efficiency
 *       maintainability
 * @precision low
 */

import javascript

/**
 * Holds if the loop `f` iterates over a non-local variable, with `descr`
 * explaining why the variable is not local.
 */
predicate nonLocalIterator(EnhancedForLoop f, string descr) {
  // iterator is a property as in `for (x.p in o) ...`
  f.getIterator() instanceof PropAccess and descr = "a property"
  or
  // iterator is not a purely local variable:
  exists(Variable v | v = f.getAnIterationVariable() |
    // either it is global...
    v.isGlobal() and descr = "a global variable"
    or
    // ...or it is captured by an inner function
    v.isLocal() and v.isCaptured() and descr = "captured"
  )
}

from EnhancedForLoop f, string reason
where
  nonLocalIterator(f, reason) and
  // exclude toplevel statements, since the toplevel is unlikely to be optimized anyway
  not f.getContainer() instanceof TopLevel
select f.getIterator(),
  "This loop may prevent optimization because its iteration variable is " + reason + "."
