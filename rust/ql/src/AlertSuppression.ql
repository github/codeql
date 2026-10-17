/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id rust/alert-suppression
 */

private import codeql.util.suppression.AlertSuppression as AS
private import codeql.rust.elements.Comment as C
private import codeql.rust.elements.AstNode as A

class AstNode instanceof A::AstNode {
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  string toString() { result = super.toString() }
}

class SingleLineComment instanceof C::Comment {
  private string text;

  SingleLineComment() {
    // Match line comments (// or ///) and extract text after the marker
    text = super.getText().regexpCapture("///?([^\\r\\n]*)", 1)
    or
    // Match single-line block comments (/* ... */ on one line)
    text = super.getText().regexpCapture("/\\*([^\\r\\n]*)\\*/", 1)
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  string getText() { result = text }

  string toString() { result = super.toString() }
}

import AS::Make<AstNode, SingleLineComment>
