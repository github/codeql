import csharp

private predicate commentLine(
  CommentBlock c, CommentLine l, int numLines, string text, string rawText
) {
  l.getParent() = c and
  numLines = c.getNumLines() and
  text = l.getText() and
  rawText = l.getRawText()
}

query predicate singlelineComment(
  CommentBlock c, SinglelineComment l, int numLines, string text, string rawText
) {
  commentLine(c, l, numLines, text, rawText)
}

query predicate multilineComment(
  CommentBlock c, MultilineComment l, int numLines, string text, string rawText
) {
  commentLine(c, l, numLines, text, rawText)
}

query predicate xmlComment(
  CommentBlock c, XmlCommentLine l, int numLines, string text, string rawText
) {
  commentLine(c, l, numLines, text, rawText)
}
