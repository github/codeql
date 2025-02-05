private import rust as R
private import codeql.mad.test.InlineMadTest

private module InlineMadTestLang implements InlineMadTestLangSig {
  class Callable = R::Function;

  string getComment(R::Function callable) {
    exists(R::Comment comment |
      result = comment.getCommentText() and
      comment.getLocation().getFile() = callable.getLocation().getFile() and
      // When a function is preceded by comments its start line is the line of
      // the first comment. Hence all relevant comments are found by including
      // comments from the start line and up to the line with the function
      // name.
      callable.getLocation().getStartLine() <= comment.getLocation().getStartLine() and
      comment.getLocation().getStartLine() <= callable.getName().getLocation().getStartLine()
    )
  }
}

import InlineMadTestImpl<InlineMadTestLang>
