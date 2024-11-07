/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id swift/alert-suppression
 */

private import codeql.util.suppression.AlertSuppression as AS
private import codeql.swift.elements.Locatable as L
private import codeql.swift.elements.Comments as C

class AstNode extends L::Locatable {
  predicate hasLocationInfo(string path, int startLine, int startColumn, int endLine, int endColumn) {
    this.getLocation().hasLocationInfo(path, startLine, startColumn, endLine, endColumn)
  }
}

class SingleLineComment extends AstNode instanceof C::Comment {
  private string text;

  SingleLineComment() {
    this instanceof C::SingleLineComment and
    text = super.getText().regexpCapture("//([^\\r\\n]*)[\\r\\n]?", 1)
    or
    this instanceof C::MultiLineComment and
    // suppression comments must be single-line
    text = super.getText().regexpCapture("/\\*([^\\r\\n]*)\\*/", 1)
  }

  override predicate hasLocationInfo(
    string path, int startLine, int startColumn, int endLine, int endColumn
  ) {
    this.(C::SingleLineComment).getLocation().hasLocationInfo(path, startLine, startColumn, _, _) and
    endLine = startLine and
    endColumn = startColumn + text.length() + 1
    or
    this.(C::MultiLineComment)
        .getLocation()
        .hasLocationInfo(path, startLine, startColumn, endLine, endColumn + 1)
  }

  string getText() { result = text }
}

import AS::Make<AstNode, SingleLineComment>
