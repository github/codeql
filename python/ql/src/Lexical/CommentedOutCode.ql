/**
 * @name Commented-out code
 * @description Commented-out code makes the remaining code more difficult to read.
 * @kind problem
 * @tags maintainability
 *       readability
 *       documentation
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/commented-out-code
 */

import python
import Lexical.CommentedOutCode

from CommentedOutCodeBlock c
where not c.maybeExampleCode()
select c, "These comments appear to contain commented-out code."
