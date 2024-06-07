private import csharp as CS
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in C# used by the InlineExpectations core code
   */
  class ExpectationComment extends CS::SinglelineComment {
    /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = this.getText() }
  }

  class Location = CS::Location;
}
