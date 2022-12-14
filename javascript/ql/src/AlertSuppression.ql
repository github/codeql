/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id js/alert-suppression
 */

private import codeql.suppression.AlertSuppression as AS
private import semmle.javascript.Locations as L

class SingleLineComment extends L::Locatable {
  private string text;

  SingleLineComment() {
    (
      text = this.(L::Comment).getText() or
      text = this.(L::HTML::CommentNode).getText()
    ) and
    // suppression comments must be single-line
    not text.matches("%\n%")
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  string getText() { result = text }
}

import AS::Make<SingleLineComment>
