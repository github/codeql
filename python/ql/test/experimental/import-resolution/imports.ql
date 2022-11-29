import python
import TestUtilities.InlineExpectationsTest
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.ImportResolution

private class ImmediateModuleRef extends DataFlow::Node {
  Module mod;
  string alias;

  ImmediateModuleRef() {
    this = ImportResolution::getImmediateModuleReference(mod) and
    not mod.getName() in ["__future__", "trace"] and
    this.asExpr() = any(Alias a | alias = a.getAsname().(Name).getId()).getAsname()
  }

  Module getModule() { result = mod }

  string getAsname() { result = alias }
}

class ImportTest extends InlineExpectationsTest {
  ImportTest() { this = "ImportTest" }

  override string getARelevantTag() { result = "imports" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ImmediateModuleRef ref |
      tag = "imports" and
      location = ref.getLocation() and
      value = ref.getModule().getName() and
      element = ref.toString()
    )
  }
}

class AliasTest extends InlineExpectationsTest {
  AliasTest() { this = "AliasTest" }

  override string getARelevantTag() { result = "as" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ImmediateModuleRef ref |
      tag = "as" and
      location = ref.getLocation() and
      value = ref.getAsname() and
      element = ref.toString()
    )
  }
}
