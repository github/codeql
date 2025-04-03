private import rust as R
private import codeql.mad.test.InlineMadTest

private module InlineMadTestLang implements InlineMadTestLangSig {
  class Callable = R::Function;

  string getComment(R::Function callable) {
    result = callable.getPrecedingComment().getCommentText()
  }
}

import InlineMadTestImpl<InlineMadTestLang>
