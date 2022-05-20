/**
 * @name Dead enum constant
 * @description Dead enum constants add unnecessary complexity.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/dead-enum-constant
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.deadcode.DeadCode

from UnusedEnumConstant e
where not e.whitelisted()
select e, e.getName() + " is unused -- its value is never obtained."
