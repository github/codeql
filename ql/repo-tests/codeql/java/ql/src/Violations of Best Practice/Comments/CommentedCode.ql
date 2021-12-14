/**
 * @name Commented-out code
 * @description Commented-out code makes the remaining code more difficult to read.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/commented-out-code
 * @tags maintainability
 *       readability
 *       statistical
 *       non-attributable
 */

import CommentedCode

from CommentedOutCode comment
select comment, "This comment appears to contain commented-out code."
