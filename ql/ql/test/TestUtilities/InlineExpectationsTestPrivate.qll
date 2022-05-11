import ql
private import codeql_ql.ast.internal.TreeSitter

private newtype TExpectationComment = MkExpectationComment(QL::LineComment comment)

/**
 * Represents a line comment.
 */
class ExpectationComment extends TExpectationComment {
  QL::LineComment comment;

  ExpectationComment() { this = MkExpectationComment(comment) }

  /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = comment.getValue().suffix(2) }

  /** Gets a textual representation of this element. */
  string toString() { result = comment.toString() }

  /** Gets the location of this comment. */
  Location getLocation() { result = comment.getLocation() }
}
