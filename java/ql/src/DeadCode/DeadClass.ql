/**
 * @name Dead class
 * @description Dead classes add unnecessary complexity.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/dead-class
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import semmle.code.java.deadcode.DeadCode

from DeadClass c, Element origin, string reason
where
  if exists(DeadRoot root | root = c.getADeadRoot() | not root = c.getACallable())
  then (
    // Report a list of the dead roots.
    origin = c.getADeadRoot() and
    not origin = c.getACallable() and
    // There are uses of this class from outside the class.
    reason = " is only used from dead code originating at $@."
  ) else (
    // There are no dead roots outside this class.
    origin = c and
    if c.isUnusedOutsideClass()
    then
      // Never accessed outside this class, so it's entirely unused.
      reason = " is entirely unused."
    else
      // There are no dead roots outside the class, but the class has a possible liveness cause
      // external to the class, so it must be accessed from at least one dead-code cycle.
      reason = " is only used from or in a dead-code cycle."
  )
select c, "The class " + c.getName() + reason, origin, origin.getName()
