/**
 * @name Direct state mutation
 * @description Mutating the state of a React component directly may lead to
 *              lost updates.
 * @kind problem
 * @problem.severity warning
 * @id js/react/direct-state-mutation
 * @tags reliability
 *       frameworks/react
 * @precision very-high
 */

import semmle.javascript.frameworks.React

from DataFlow::PropWrite pwn, ReactComponent c
where
  pwn.getBase() = c.getAStateAccess() and
  // writes in constructors are ok
  not pwn.getContainer() instanceof Constructor
select pwn, "Use `setState` instead of directly modifying component state."
