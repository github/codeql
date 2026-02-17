/**
 * Provides an inline expectations test for path resolution.
 */

private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.typeinference.TypeInference
private import utils.test.InlineExpectationsTest

private module ResolveTest implements TestSig {
  string getARelevantTag() { result = ["item", "target", "item_not_target"] }

  private predicate itemAt(ItemNode i, string filepath, int line) {
    i.getLocation().hasLocationInfo(filepath, _, _, line, _)
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
    exists(string filepath, int line | itemAt(i, filepath, line) |
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

  private Item getCallExprTarget(Path p) {
    exists(CallExpr ce |
      p = ce.getFunction().(PathExpr).getPath() and
      result = ce.getResolvedTarget()
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(AstNode n, ItemNode i |
      not n = any(Path parent).getQualifier() and
      location = n.getLocation() and
      n.fromSource() and
      not location.getFile().getAbsolutePath().matches("%proc_macro.rs") and
      not n.isFromMacroExpansion() and
      element = n.toString() and
      item(i, value)
    |
      i = resolvePath(n) and
      (
        if exists(getCallExprTarget(n)) and not i = getCallExprTarget(n)
        then tag = "item_not_target"
        else tag = "item"
      )
      or
      tag = "target" and
      (
        i = n.(MethodCallExpr).getStaticTarget()
        or
        i = getCallExprTarget(n) and
        not i = resolvePath(n)
      )
    )
  }
}

import MakeTest<ResolveTest>
