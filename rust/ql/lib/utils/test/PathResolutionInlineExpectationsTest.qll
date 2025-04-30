/**
 * Provides an inline expectations test for path resolution.
 */

private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.TypeInference
private import utils.test.InlineExpectationsTest

private module ResolveTest implements TestSig {
  string getARelevantTag() { result = "item" }

  private predicate itemAt(ItemNode i, string filepath, int line, boolean inMacro) {
    i.getLocation().hasLocationInfo(filepath, _, _, line, _) and
    if i.(AstNode).isInMacroExpansion() then inMacro = true else inMacro = false
  }

  private predicate commmentAt(string text, string filepath, int line) {
    exists(Comment c |
      c.getLocation().hasLocationInfo(filepath, line, _, _, _) and
      c.getCommentText().trim() = text
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
