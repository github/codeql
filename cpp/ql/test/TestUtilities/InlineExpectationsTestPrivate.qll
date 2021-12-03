import cpp

private newtype TExpectationComment = MkExpectationComment(CppStyleComment c)

/**
 * Represents a line comment in the CPP style.
 * Unlike the `CppStyleComment` class, however, the string returned by `getContents` does _not_
 * include the preceding comment marker (`//`).
 */
class ExpectationComment extends TExpectationComment {
  CppStyleComment comment;

  ExpectationComment() { this = MkExpectationComment(comment) }

  /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = comment.getContents().suffix(2) }

  /** Gets a textual representation of this element. */
  string toString() { result = comment.toString() }

  /** Gets the location of this comment. */
  Location getLocation() { result = comment.getLocation() }
}
