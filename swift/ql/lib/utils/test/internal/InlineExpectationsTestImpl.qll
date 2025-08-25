private import swift as S
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private newtype TExpectationComment = MkExpectationComment(S::SingleLineComment c)

  /**
   * A class representing a line comment.
   * Unlike the `SingleLineComment` class, however, the string returned by `getContents` does _not_
   * include the preceding comment marker (`//`).
   */
  class ExpectationComment extends TExpectationComment {
    S::SingleLineComment comment;

    ExpectationComment() { this = MkExpectationComment(comment) }

    /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = comment.getText().suffix(2) }

    /** Gets a textual representation of this element. */
    string toString() { result = comment.toString() }

    /** Gets the location of this comment. */
    Location getLocation() { result = comment.getLocation() }
  }

  class Location = S::Location;
}
