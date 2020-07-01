/**
 * Provides heuristics to find "todo" and "fixme" comments (in all caps).
 */

import cpp

/**
 * Gets a string representation of the comment `c` containing the caption 'TODO' or 'FIXME'.
 * If `c` spans multiple lines, all lines after the first are abbreviated as [...].
 */
string getCommentTextCaptioned(Comment c, string caption) {
  (caption = "TODO" or caption = "FIXME") and
  exists(
    string commentContents, string commentBody, int offset, string interestingSuffix, int endOfLine,
    string dontCare, string captionedLine, string followingLine
  |
    commentContents = c.getContents() and
    commentContents.matches("%" + caption + "%") and
    // Add some '\n's so that any interesting line, and its
    // following line, will definitely begin and end with '\n'.
    commentBody = commentContents.regexpReplaceAll("(?s)^/\\*(.*)\\*/$|^//(.*)$", "\n$1$2\n\n") and
    dontCare = commentBody.regexpFind("\\n[/* \\t\\x0B\\f\\r]*" + caption, _, offset) and
    interestingSuffix = commentBody.suffix(offset) and
    endOfLine = interestingSuffix.indexOf("\n", 1, 0) and
    captionedLine =
      interestingSuffix
          .prefix(endOfLine)
          .regexpReplaceAll("^[/*\\s]*" + caption + "\\s*:?", "")
          .trim() and
    followingLine =
      interestingSuffix.prefix(interestingSuffix.indexOf("\n", 2, 0)).suffix(endOfLine).trim() and
    if captionedLine = ""
    then result = caption + " comment"
    else
      if followingLine = ""
      then result = caption + " comment: " + captionedLine
      else result = caption + " comment: " + captionedLine + " [...]"
  )
}
