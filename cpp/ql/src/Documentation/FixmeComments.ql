/**
 * @name FIXME comment
 * @description Comments containing 'FIXME' indicate that the code has known bugs.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/fixme-comment
 * @tags maintainability
 *       documentation
 *       external/cwe/cwe-546
 */

import cpp
import Documentation.CaptionedComments

from Comment c, string message
where message = getCommentTextCaptioned(c, "FIXME")
select c, message
