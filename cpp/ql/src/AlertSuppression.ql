/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id cpp/alert-suppression
 */

private import codeql.util.suppression.AlertSuppression as AS
private import semmle.code.cpp.Element

class AstNode extends Locatable {
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

class SingleLineComment extends Comment, AstNode {
  private string text;

  SingleLineComment() {
    this instanceof CppStyleComment and
    // strip the beginning slashes
    text = this.getContents().suffix(2)
    or
    this instanceof CStyleComment and
    // strip both the beginning /* and the end */ the comment
    exists(string text0 |
      text0 = this.getContents().suffix(2) and
      text = text0.prefix(text0.length() - 2)
    ) and
    // The /* */ comment must be a single-line comment
    not text.matches("%\n%")
  }

  /** Gets the text in this comment, excluding the leading //. */
  string getText() { result = text }
}

import AS::Make<AstNode, SingleLineComment>
