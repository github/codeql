/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id py/alert-suppression
 */

private import codeql.util.suppression.AlertSuppression as AS
private import semmle.python.Comment as P

class AstNode instanceof P::AstNode {
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  string toString() { result = super.toString() }
}

class SingleLineComment instanceof P::Comment {
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  string getText() { result = super.getContents() }

  string toString() { result = super.toString() }
}

import AS::Make<AstNode, SingleLineComment>

/**
 * A noqa suppression comment. Both pylint and pyflakes respect this, so lgtm ought to too.
 */
class NoqaSuppressionComment extends SuppressionComment instanceof SingleLineComment {
  NoqaSuppressionComment() {
    SingleLineComment.super.getText().regexpMatch("(?i)\\s*noqa\\s*([^:].*)?")
  }

  override string getAnnotation() { result = "lgtm" }

  override predicate covers(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.hasLocationInfo(filepath, startline, _, endline, endcolumn) and
    startcolumn = 1
  }
}
