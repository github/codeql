private import javascript as JS
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private import javascript

  final private class LineCommentFinal = LineComment;

  class ExpectationComment extends LineCommentFinal {
    string getContents() { result = this.getText() }

    /** Gets this element's location. */
    Location getLocation() { result = super.getLocation() }
  }

  class Location = JS::Location;
}
