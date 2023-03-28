/**
 * Inline expectation tests for CSharp.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import csharp as CS
private import codeql.util.test.InlineExpectationsTest

private module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in C# used by the InlineExpectations core code
   */
  class ExpectationComment extends CS::SinglelineComment {
    /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = this.getText() }
  }

  class Location = CS::Location;
}

import Make<Impl>
