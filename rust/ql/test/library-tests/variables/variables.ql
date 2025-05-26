import rust
import utils.test.InlineExpectationsTest
import codeql.rust.elements.internal.VariableImpl::Impl as VariableImpl
import TestUtils

query predicate variable(Variable v) { toBeTested(v.getEnclosingCfgScope()) }

query predicate variableAccess(VariableAccess va, Variable v) {
  variable(v) and toBeTested(va) and v = va.getVariable()
}

query predicate variableWriteAccess(VariableWriteAccess va, Variable v) {
  variable(v) and toBeTested(va) and v = va.getVariable()
}

query predicate variableReadAccess(VariableReadAccess va, Variable v) {
  variable(v) and toBeTested(va) and v = va.getVariable()
}

query predicate variableInitializer(Variable v, Expr e) {
  variable(v) and toBeTested(e) and e = v.getInitializer()
}

query predicate capturedVariable(Variable v) { variable(v) and v.isCaptured() }

query predicate capturedAccess(VariableAccess va) { toBeTested(va) and va.isCapture() }

query predicate nestedFunctionAccess(VariableImpl::NestedFunctionAccess nfa, Function f) {
  toBeTested(f) and f = nfa.getFunction()
}

module VariableAccessTest implements TestSig {
  string getARelevantTag() { result = ["", "write_", "read_"] + "access" }

  private predicate declAt(Variable v, string filepath, int line, boolean inMacro) {
    variable(v) and
    v.getLocation().hasLocationInfo(filepath, _, _, line, _) and
    if v.getPat().isInMacroExpansion() then inMacro = true else inMacro = false
  }

  private predicate commmentAt(string text, string filepath, int line) {
    exists(Comment c |
      c.getLocation().hasLocationInfo(filepath, line, _, _, _) and
      c.getCommentText().trim() = text
    )
  }

  private predicate decl(Variable v, string value) {
    exists(string filepath, int line, boolean inMacro | declAt(v, filepath, line, inMacro) |
      commmentAt(value, filepath, line) and inMacro = false
      or
      not (commmentAt(_, filepath, line) and inMacro = false) and
      value = v.getText()
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(VariableAccess va |
      toBeTested(va) and
      location = va.getLocation() and
      element = va.toString() and
      decl(va.getVariable(), value)
    |
      va instanceof VariableWriteAccess and tag = "write_access"
      or
      va instanceof VariableReadAccess and tag = "read_access"
      or
      not va instanceof VariableWriteAccess and
      not va instanceof VariableReadAccess and
      tag = "access"
    )
  }
}

import MakeTest<VariableAccessTest>
