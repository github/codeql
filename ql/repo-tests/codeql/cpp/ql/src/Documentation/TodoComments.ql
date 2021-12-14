/**
 * @name TODO comment
 * @description Comments containing 'TODO' indicate that the code may be in an incomplete state.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cpp/todo-comment
 * @tags maintainability
 *       documentation
 *       external/cwe/cwe-546
 */

import cpp
import Documentation.CaptionedComments

from Comment c, string message
where message = getCommentTextCaptioned(c, "TODO")
select c, message
