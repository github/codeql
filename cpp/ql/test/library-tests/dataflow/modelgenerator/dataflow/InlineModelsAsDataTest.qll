private import cpp
private import codeql.mad.test.InlineMadTest

class MadRelevantFunction extends Function {
  MadRelevantFunction() { not this.isFromUninstantiatedTemplate(_) }
}

private module InlineMadTestLang implements InlineMadTestLangSig {
  class Callable = MadRelevantFunction;

  /**
   * Holds if `c` is the closest `Callable` that succeeds `comment` in the file.
   */
  private predicate hasClosestCallable(CppStyleComment comment, Callable c) {
    c =
      min(Callable cand, int dist |
        // This has no good join order, but should hopefully be good enough for tests.
        cand.getFile() = comment.getFile() and
        dist = cand.getLocation().getStartLine() - comment.getLocation().getStartLine() and
        dist > 0
      |
        cand order by dist
      )
  }

  string getComment(Callable c) {
    exists(CppStyleComment comment |
      hasClosestCallable(comment, c) and
      result = comment.getContents().suffix(2)
    )
  }
}

import InlineMadTestImpl<InlineMadTestLang>
