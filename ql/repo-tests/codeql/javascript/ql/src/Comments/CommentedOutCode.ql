/**
 * @name Commented-out code
 * @description Comments that contain commented-out code should be avoided.
 * @kind problem
 * @problem.severity recommendation
 * @id js/commented-out-code
 * @tags maintainability
 *       statistical
 *       non-attributable
 * @precision medium
 */

import javascript
import CommentedOut

/**
 * Holds if comment `c` looks like an annotation for the [Flow](https://flowtype.org/)
 * type checker.
 */
predicate isFlowAnnotation(SlashStarComment c) {
  c.getText().regexpMatch("^(?s)\\s*(: |::|flow-include ).*")
}

from CommentedOutCode c
where not isFlowAnnotation(c)
select c, "This comment appears to contain commented-out code."
