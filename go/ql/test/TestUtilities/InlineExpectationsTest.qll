/**
 * Inline expectation tests for Go.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import go as G
private import codeql.util.test.InlineExpectationsTest

/**
 * Represents a line comment in the Go style.
 * include the preceding comment marker (`//`).
 */
private class ExpectationComment extends G::Comment {
  /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = this.getText() }
}

import Make<ExpectationComment>
