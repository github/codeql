/**
 * Inline expectation tests for QL.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import ql as QL
private import codeql.util.test.InlineExpectationsTest

private module Impl implements InlineExpectationsTestSig {
  private import codeql_ql.ast.internal.TreeSitter as TS

  private newtype TExpectationComment = MkExpectationComment(TS::QL::LineComment comment)

  /**
   * Represents a line comment.
   */
  class ExpectationComment extends TExpectationComment {
    TS::QL::LineComment comment;

    ExpectationComment() { this = MkExpectationComment(comment) }

    /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = comment.getValue().suffix(2) }

    /** Gets a textual representation of this element. */
    string toString() { result = comment.toString() }

    /** Gets the location of this comment. */
    Location getLocation() { result = comment.getLocation() }
  }

  class Location = QL::Location;
}

import Make<Impl>
