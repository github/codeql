private import java as J
private import codeql.mad.test.InlineMadTest

private module InlineMadTestLang implements InlineMadTestLangSig {
  class Callable = J::Callable;

  string getComment(Callable c) {
    exists(J::Javadoc doc |
      hasJavadoc(c, doc) and
      isNormalComment(doc) and
      result = doc.getChild(0).toString()
    )
  }
}

import InlineMadTestImpl<InlineMadTestLang>
