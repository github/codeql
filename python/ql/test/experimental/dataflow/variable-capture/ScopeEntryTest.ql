import python
import semmle.python.essa.Essa
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

class ScopeEntryTest extends InlineExpectationsTest {
  ScopeEntryTest() { this = "ScopeEntryTest" }

  override string getARelevantTag() { result = "entry" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ScopeEntryDefinition def |
      exists(def.getLocation().getFile().getRelativePath()) and
      not def instanceof GlobalSsaVariable and
      not def.(EssaVariable).isMetaVariable()
    |
      location = def.getLocation() and
      tag = "entry" and
      value = prettyEssaDefinition(def) and
      element = def.toString()
    )
  }
}

string prettyEssaDefinition(EssaDefinition def) {
  result = def.(EssaVariable).getSourceVariable().getName()
}
