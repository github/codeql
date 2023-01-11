/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id java/alert-suppression
 */

private import codeql.util.suppression.AlertSuppression as AS
private import semmle.code.java.Javadoc

class SingleLineComment extends Javadoc {
  SingleLineComment() {
    isEolComment(this)
    or
    isNormalComment(this) and exists(int line | this.hasLocationInfo(_, line, _, line, _))
  }

  string getText() { result = this.getChild(0).getText() }
}

import AS::Make<Top, SingleLineComment>
