/**
 * Inline expectation tests for Go.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import go as G
private import codeql.util.test.InlineExpectationsTest

private module Impl implements InlineExpectationsTestSig {
  /**
   * Represents a line comment in the Go style.
   * include the preceding comment marker (`//`).
   */
  class ExpectationComment extends G::Comment {
    /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = this.getText() }
  }

  class Location = G::Location;
}

import Make<Impl>
