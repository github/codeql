import python
import utils.test.InlineExpectationsTest
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

module ImportTest implements TestSig {
  string getARelevantTag() { result = "imports" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ImmediateModuleRef ref |
      tag = "imports" and
      location = ref.getLocation() and
      value = ref.getModule().getName() and
      element = ref.toString()
    )
  }
}

module AliasTest implements TestSig {
  string getARelevantTag() { result = "as" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ImmediateModuleRef ref |
      tag = "as" and
      location = ref.getLocation() and
      value = ref.getAsname() and
      element = ref.toString()
    )
  }
}

import MakeTest<MergeTests<ImportTest, AliasTest>>
