import rust
import utils.InlineExpectationsTest

query predicate variable(Variable v) { any() }

query predicate variableAccess(VariableAccess va, Variable v) { v = va.getVariable() }

query predicate variableWriteAccess(VariableWriteAccess va, Variable v) { v = va.getVariable() }

query predicate variableReadAccess(VariableReadAccess va, Variable v) { v = va.getVariable() }

query predicate variableInitializer(Variable v, Expr e) { e = v.getInitializer() }

module VariableAccessTest implements TestSig {
  string getARelevantTag() { result = "access" }

  private predicate declAt(Variable v, string filepath, int line) {
    v.getLocation().hasLocationInfo(filepath, _, _, line, _)
  }

  private predicate commmentAt(string text, string filepath, int line) {
    exists(Comment c |
      c.getLocation().hasLocationInfo(filepath, line, _, _, _) and
      c.getCommentText() = text
    )
  }

  private predicate decl(Variable v, string value) {
    exists(string filepath, int line | declAt(v, filepath, line) |
      commmentAt(value, filepath, line)
      or
      not commmentAt(_, filepath, line) and
      value = v.getName()
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(VariableAccess va |
      location = va.getLocation() and
      element = va.toString() and
      tag = "access" and
      decl(va.getVariable(), value)
    )
  }
}

import MakeTest<VariableAccessTest>
