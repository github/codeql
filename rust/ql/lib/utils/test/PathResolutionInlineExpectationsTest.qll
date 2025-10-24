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
      c.getCommentText().trim() = text and
      c.fromSource() and
      not text.matches("$%")
    )
  }

  private predicate item(ItemNode i, string value) {
    exists(string filepath, int line, boolean inMacro | itemAt(i, filepath, line, inMacro) |
      if i instanceof SourceFile
      then value = i.getFile().getBaseName()
      else (
        commmentAt(value, filepath, line)
        or
        not commmentAt(_, filepath, line) and
        value = i.getName()
      )
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(AstNode n |
      not n = any(Path parent).getQualifier() and
      location = n.getLocation() and
      n.fromSource() and
      not location.getFile().getAbsolutePath().matches("%proc_macro.rs") and
      not n.isFromMacroExpansion() and
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
