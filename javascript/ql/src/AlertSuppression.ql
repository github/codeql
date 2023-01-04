/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id js/alert-suppression
 */

private import codeql.util.suppression.AlertSuppression as AS
private import javascript as JS

class AstNode extends JS::Locatable {
  AstNode() { not this.(JS::HTML::TextNode).getText().regexpMatch("\\s*") }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

class SingleLineComment extends AstNode {
  private string text;

  SingleLineComment() {
    (
      text = this.(JS::Comment).getText() or
      text = this.(JS::HTML::CommentNode).getText()
    ) and
    // suppression comments must be single-line
    not text.matches("%\n%")
  }

  string getText() { result = text }
}

import AS::Make<AstNode, SingleLineComment>
