private import csharp as CS
private import codeql.mad.test.InlineMadTest

private module InlineMadTestLang implements InlineMadTestLangSig {
  class Callable = CS::Callable;

  string getComment(Callable c) {
    exists(CS::CommentBlock block, CS::Element after | after = block.getAfter() |
      (
        after = c or
        after = c.(CS::Accessor).getDeclaration()
      ) and
      result = block.getALine()
    )
  }
}

import InlineMadTestImpl<InlineMadTestLang>
