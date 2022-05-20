/**
 * @name Dead method
 * @description Dead methods add unnecessary complexity.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/dead-function
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.deadcode.DeadCode

from DeadMethod c, Callable origin, string reason
where
  not c.isInDeadScope() and
  if exists(DeadRoot deadRoot | deadRoot = getADeadRoot(c) | deadRoot.getSourceDeclaration() != c)
  then (
    // We've found a dead root that is not this callable (or an instantiation thereof).
    origin = getADeadRoot(c).getSourceDeclaration() and
    reason = " is only used from dead code originating at $@."
  ) else (
    origin = c and
    if
      exists(Callable cause | cause = possibleLivenessCause(c) and not cause instanceof DeadRoot |
        cause.getSourceDeclaration() = c
        implies
        possibleLivenessCause(cause).getSourceDeclaration() != c
      )
    then
      // There are no dead roots that are not this callable (or an instantiation thereof), and at least one
      // liveness cause (ignoring trivial cycles between a parameterized callable and its source declaration).
      reason = " is only used from, or in, a dead-code cycle."
    else reason = " is entirely unused."
  )
select c, "The method " + c.getName() + reason, origin, origin.getName()
