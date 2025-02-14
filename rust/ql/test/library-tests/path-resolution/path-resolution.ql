import rust
import codeql.rust.elements.internal.PathResolution
import utils.test.InlineExpectationsTest

query predicate mod(Module m) { any() }

query predicate resolvePath(Path p, ItemNode i) { i = resolvePath(p) }

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
    exists(Path p |
      not p = any(Path parent).getQualifier() and
      location = p.getLocation() and
      element = p.toString() and
      item(resolvePath(p), value) and
      tag = "item"
    )
  }
}

import MakeTest<ResolveTest>
