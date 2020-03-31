/**
 * @name Expression has no effect
 * @description An expression that has no effect and is used in a void context is most
 *              likely redundant and may indicate a bug.
 * @kind problem
 * @problem.severity warning
 * @id js/useless-expression
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-561
 * @precision very-high
 */

import javascript
import ExprHasNoEffect
import semmle.javascript.RestrictedLocations

from Expr e
where hasNoEffect(e)
select e.(FirstLineOf), "This expression has no effect."
