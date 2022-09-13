private import codeql.swift.generated.Comment

class Comment extends CommentBase {
  /** toString */
  override string toString() { result = this.getText() }
}

class SingleLineComment extends Comment {
  SingleLineComment() {
    this.getText().matches("//%") and
    not this instanceof SingleLineDocComment
  }
}

class MultiLineComment extends Comment {
  MultiLineComment() {
    this.getText().matches("/*%") and
    not this instanceof MultiLineDocComment
  }
}

class DocComment extends Comment {
  DocComment() {
    this instanceof SingleLineDocComment or
    this instanceof MultiLineDocComment
  }
}

class SingleLineDocComment extends Comment {
  SingleLineDocComment() { this.getText().matches("///%") }
}

class MultiLineDocComment extends Comment {
  MultiLineDocComment() { this.getText().matches("/**%") }
}
