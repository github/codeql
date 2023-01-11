/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id cs/alert-suppression
 */

private import codeql.util.suppression.AlertSuppression as AS
private import semmle.code.csharp.Comments

class AstNode extends Element {
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

class SingleLineComment extends CommentLine {
  SingleLineComment() {
    // Must be either `// ...` or `/* ... */` on a single line.
    this.getRawText().regexpMatch("//.*|/\\*.*\\*/")
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

import AS::Make<AstNode, SingleLineComment>
