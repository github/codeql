private import rust as R
private import R
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in C# used by the InlineExpectations core code
   */
  class ExpectationComment extends R::Comment {
    /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = this.getCommentText() }
  }

  class Location = R::Location;
}
