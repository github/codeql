private import Raw

class Comment extends @comment_entity {
  Location getLocation() { comment_entity_location(this, result) }

  StringLiteral getCommentContents() { comment_entity(this, result) }

  string toString() { result = this.getCommentContents().toString() }
}

class SingleLineComment extends Comment {
  SingleLineComment() { this.getCommentContents().getNumContinuations() = 1 }
}

class MultiLineComment extends Comment {
  MultiLineComment() { this.getCommentContents().getNumContinuations() > 1 }
}
