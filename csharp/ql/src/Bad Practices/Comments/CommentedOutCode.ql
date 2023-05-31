/**
 * @name Commented-out code
 * @description Commented-out code makes the remaining code more difficult to read.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/commented-out-code
 * @tags maintainability
 *       statistical
 *       non-attributable
 */

import csharp

class CommentedOutCode extends CommentBlock {
  CommentedOutCode() {
    not this.isXmlCommentBlock() and
    2 * count(this.getAProbableCodeLine()) > count(this.getANonEmptyLine())
  }
}

from CommentedOutCode comment
select comment, "This comment appears to contain commented-out code."
