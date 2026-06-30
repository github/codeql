private import unified as U
private import U
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  class ExpectationComment extends U::Comment {
    /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = this.getCommentText() }
  }

  class Location = U::Location;
}
