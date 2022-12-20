/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id rb/alert-suppression
 */

private import codeql.suppression.AlertSuppression as AS
private import codeql.ruby.ast.internal.TreeSitter

class SingleLineComment extends Ruby::Comment {
  SingleLineComment() {
    // suppression comments must be single-line
    this.getLocation().getStartLine() = this.getLocation().getEndLine()
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets the suppression annotation in this comment. */
  string getText() { result = this.getValue().suffix(1) }
}

import AS::Make<SingleLineComment>
