private import javascript as JS
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private import javascript

  final class ExpectationComment = ExpectationCommentImpl;

  class Location = JS::Location;

  abstract private class ExpectationCommentImpl extends Locatable {
    abstract string getContents();

    /** Gets this element's location. */
    Location getLocation() { result = super.getLocation() }
  }

  private class JSComment extends ExpectationCommentImpl instanceof Comment {
    override string getContents() { result = super.getText() }
  }

  private class HtmlComment extends ExpectationCommentImpl instanceof HTML::CommentNode {
    override string getContents() { result = super.getText() }
  }
}
