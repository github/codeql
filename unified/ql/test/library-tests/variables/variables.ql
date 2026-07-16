import unified
import utils.test.InlineExpectationsTest

/** Holds if a comment with `text` appears at `filepath:line`, excluding the text in a `$` section. */
predicate plainCommentAt(string filepath, int line, string text) {
  exists(Comment comment |
    comment.getLocation().hasLocationInfo(filepath, line, _, _, _) and
    text = comment.getCommentText().regexpReplaceAll("\\$([^/]|/[^/])*", "")
  )
}

/** Holds if a `key=value` comment appears on `filepath:line` (not in the `$` section). */
predicate keyValueCommentAt(string filepath, int line, string key, string value) {
  exists(string text, string regexp, string match |
    plainCommentAt(filepath, line, text) and
    regexp = "(\\w+)=(\\w+)" and
    match = text.regexpFind(regexp, _, _) and
    key = match.regexpCapture(regexp, 1) and
    value = match.regexpCapture(regexp, 2)
  )
}

module VariableAccessTest implements TestSig {
  string getARelevantTag() { result = "access" }

  private predicate declAt(Variable v, string filepath, int line) {
    v.getLocation().hasLocationInfo(filepath, _, _, line, _)
  }

  private predicate decl(Variable v, string alias) {
    exists(string filepath, int line | declAt(v, filepath, line) |
      keyValueCommentAt(filepath, line, "name", alias)
      or
      not keyValueCommentAt(filepath, line, "name", _) and
      alias = v.getName()
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(VariableAccess va, Variable v |
      v = va.getVariable() and
      not va = v.getDefiningNode() and
      location = va.getLocation() and
      element = va.toString() and
      decl(v, value) and
      tag = "access"
    )
  }
}

import MakeTest<VariableAccessTest>
