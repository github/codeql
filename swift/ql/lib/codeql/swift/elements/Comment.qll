private import codeql.swift.generated.Comment

class Comment extends CommentBase {
  /** toString */
  override string toString() { result = getText() }
}
