private import go as G
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in the Go style, including the
   * preceding comment marker (`//`).
   */
  class ExpectationComment extends G::Comment {
    /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = this.getText() }
  }

  class Location = G::Location;
}
