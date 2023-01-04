/**
 * Inline expectation tests for QL.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import ql as QL
private import codeql.util.test.InlineExpectationsTest
private import codeql_ql.ast.internal.TreeSitter as TS

private newtype TExpectationComment = MkExpectationComment(TS::QL::LineComment comment)

/**
 * Represents a line comment.
 */
private class ExpectationComment extends TExpectationComment {
  TS::QL::LineComment comment;

  ExpectationComment() { this = MkExpectationComment(comment) }

  /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = comment.getValue().suffix(2) }

  /** Gets a textual representation of this element. */
  string toString() { result = comment.toString() }

  predicate hasLocationInfo(string file, int line, int column, int endLine, int endColumn) {
    comment.getLocation().hasLocationInfo(file, line, column, endLine, endColumn)
  }
}

import Make<ExpectationComment>
