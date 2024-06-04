private import java as J
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in Java, which is simply Javadoc restricted
   * to EOL comments, with an extra accessor used by the InlineExpectations core code
   */
  abstract class ExpectationComment extends J::Top {
    /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
    abstract string getContents();
  }

  private class JavadocExpectationComment extends J::Javadoc, ExpectationComment {
    JavadocExpectationComment() { isEolComment(this) }

    override string getContents() { result = this.getChild(0).toString() }
  }

  private class KtExpectationComment extends J::KtComment, ExpectationComment {
    KtExpectationComment() { this.isEolComment() }

    override string getContents() { result = this.getText().suffix(2).trim() }
  }

  private class XmlExpectationComment extends ExpectationComment instanceof J::XmlComment {
    override string getContents() { result = super.getText().trim() }

    override Location getLocation() { result = J::XmlComment.super.getLocation() }

    override string toString() { result = J::XmlComment.super.toString() }
  }

  class Location = J::Location;
}
