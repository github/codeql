import Comment

final class SingleLineComment extends Comment {
  SingleLineComment() {
    this.getText().matches("//%") and
    not this instanceof SingleLineDocComment
  }
}

final class MultiLineComment extends Comment {
  MultiLineComment() {
    this.getText().matches("/*%") and
    not this instanceof MultiLineDocComment
  }
}

abstract private class DocCommentImpl extends Comment { }

final class DocComment = DocCommentImpl;

final class SingleLineDocComment extends DocCommentImpl {
  SingleLineDocComment() { this.getText().matches("///%") }
}

final class MultiLineDocComment extends DocCommentImpl {
  MultiLineDocComment() { this.getText().matches("/**%") }
}
