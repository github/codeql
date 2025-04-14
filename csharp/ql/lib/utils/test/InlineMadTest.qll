private import csharp as Cs
private import codeql.mad.test.InlineMadTest

private module InlineMadTestLang implements InlineMadTestLangSig {
  class Callable = Cs::Callable;

  string getComment(Callable c) {
    exists(Cs::CommentBlock block, Cs::Element after | after = block.getAfter() |
      (
        after = c or
        after = c.(Cs::Accessor).getDeclaration()
      ) and
      result = block.getALine()
    )
  }
}

import InlineMadTestImpl<InlineMadTestLang>
