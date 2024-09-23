private import powershell as P
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in Powershell.
   */
  class ExpectationComment extends P::SingleLineComment {
    string getContents() { result = this.getCommentContents().getValue().suffix(1) }
  }

  class Location = P::Location;
}
