import powershell

class CommentEntity extends @comment_entity {
  SourceLocation getLocation() { comment_entity_location(this, result) }

  StringLiteral getCommentContents() { comment_entity(this, result) }

  string toString() { result = "Comment at: " + this.getLocation().toString() }
}
