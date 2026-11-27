import Comment

final class SingleLineComment extends Comment {
  SingleLineComment() {
    this.getText().startsWith("//") and
    not this instanceof SingleLineDocComment
  }
}

final class MultiLineComment extends Comment {
  MultiLineComment() {
    this.getText().startsWith("/*") and
    not this instanceof MultiLineDocComment
  }
}

abstract private class DocCommentImpl extends Comment { }

final class DocComment = DocCommentImpl;

final class SingleLineDocComment extends DocCommentImpl {
  SingleLineDocComment() { this.getText().startsWith("///") }
}

final class MultiLineDocComment extends DocCommentImpl {
  MultiLineDocComment() { this.getText().startsWith("/**") }
}
