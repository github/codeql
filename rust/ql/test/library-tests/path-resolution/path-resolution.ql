import rust
import codeql.rust.internal.PathResolution
import codeql.rust.internal.TypeInference
import utils.test.InlineExpectationsTest
import TestUtils

query predicate mod(Module m) { toBeTested(m) }

query predicate resolvePath(Path p, ItemNode i) { toBeTested(p) and i = resolvePath(p) }

module ResolveTest implements TestSig {
  string getARelevantTag() { result = "item" }

  private predicate itemAt(ItemNode i, string filepath, int line, boolean inMacro) {
    i.getLocation().hasLocationInfo(filepath, _, _, line, _) and
    if i.isInMacroExpansion() then inMacro = true else inMacro = false
  }

  private predicate commmentAt(string text, string filepath, int line) {
    exists(Comment c |
      c.getLocation().hasLocationInfo(filepath, line, _, _, _) and
      c.getCommentText() = text
    )
  }

  private predicate item(ItemNode i, string value) {
    exists(string filepath, int line, boolean inMacro | itemAt(i, filepath, line, inMacro) |
      commmentAt(value, filepath, line) and inMacro = false
      or
      not (commmentAt(_, filepath, line) and inMacro = false) and
      value = i.getName()
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(AstNode n |
      not n = any(Path parent).getQualifier() and
      location = n.getLocation() and
      element = n.toString() and
      tag = "item"
    |
      item(resolvePath(n), value)
      or
      item(n.(MethodCallExpr).getStaticTarget(), value)
    )
  }
}

import MakeTest<ResolveTest>
