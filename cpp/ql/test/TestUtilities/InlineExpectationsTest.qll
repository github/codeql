/**
 * Inline expectation tests for C++.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

import cpp as C
private import codeql.util.test.InlineExpectationsTest

private newtype TExpectationComment = MkExpectationComment(C::CppStyleComment c)

/**
 * Represents a line comment in the CPP style.
 * Unlike the `CppStyleComment` class, however, the string returned by `getContents` does _not_
 * include the preceding comment marker (`//`).
 */
private class ExpectationComment extends TExpectationComment {
  C::CppStyleComment comment;

  ExpectationComment() { this = MkExpectationComment(comment) }

  /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = comment.getContents().suffix(2) }

  /** Gets a textual representation of this element. */
  string toString() { result = comment.toString() }

  predicate hasLocationInfo(string file, int line, int column, int endLine, int endColumn) {
    comment.getLocation().hasLocationInfo(file, line, column, endLine, endColumn)
  }
}

import Make<ExpectationComment>
