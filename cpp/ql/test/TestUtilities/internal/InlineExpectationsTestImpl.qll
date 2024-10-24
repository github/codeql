import cpp as C
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private newtype TExpectationComment = MkExpectationComment(C::CppStyleComment c)

  /**
   * A class representing a line comment in the CPP style.
   * Unlike the `CppStyleComment` class, however, the string returned by `getContents` does _not_
   * include the preceding comment marker (`//`).
   */
  class ExpectationComment extends TExpectationComment {
    C::CppStyleComment comment;

    ExpectationComment() { this = MkExpectationComment(comment) }

    /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = comment.getContents().suffix(2) }

    /** Gets a textual representation of this element. */
    string toString() { result = comment.toString() }

    /** Gets the location of this comment. */
    Location getLocation() { result = comment.getLocation() }
  }

  class Location = C::Location;
}
