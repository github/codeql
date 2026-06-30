private import unified as U
private import U
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  class ExpectationComment extends U::Comment {
    /** Gets the text inside this comment, without the surrounding comment delimiters. */
    string getContents() { result = this.getCommentText() }
  }

  class Location = U::Location;
}
