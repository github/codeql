/**
 * @name Useless parameter
 * @description Parameters that are not used add unnecessary complexity to an interface.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/unused-parameter
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import semmle.code.java.deadcode.DeadCode

from RootdefCallable c
where not c.whitelisted()
select c.unusedParameter() as p, "The parameter " + p + " is unused."
