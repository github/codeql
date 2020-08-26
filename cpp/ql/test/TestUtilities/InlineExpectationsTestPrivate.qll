import cpp

private newtype TLineComment = MkLineComment(CppStyleComment c)

class LineComment extends TLineComment {
  CppStyleComment comment;

  LineComment() { this = MkLineComment(comment) }

  string getContents() { result = comment.getContents().suffix(2) }

  string toString() { result = comment.toString() }

  Location getLocation() { result = comment.getLocation() }
}
