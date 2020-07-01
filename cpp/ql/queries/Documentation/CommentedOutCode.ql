/**
 * @name Commented-out code
 * @description Commented-out code makes the remaining code more difficult to read.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/commented-out-code
 * @tags maintainability
 *       documentation
 */

import CommentedOutCode

from CommentedOutCode comment
select comment, "This comment appears to contain commented-out code"
