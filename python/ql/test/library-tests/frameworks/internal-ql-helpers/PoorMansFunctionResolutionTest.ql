private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
import utils.test.InlineExpectationsTest

module InlinePoorMansFunctionResolutionTest implements TestSig {
  string getARelevantTag() { result = "resolved" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Function func, DataFlow::Node ref |
      ref = poorMansFunctionTracker(func) and
      not ref.asExpr() instanceof FunctionExpr and
      // exclude the name of a defined function
      not exists(FunctionDef def | def.getDefinedFunction() = func |
        ref.asExpr() = def.getATarget()
      ) and
      // exclude decorator calls (which with our extractor rewrites does reference the
      // function)
      not ref.asExpr() = func.getDefinition().(FunctionExpr).getADecoratorCall()
    |
      value = func.getName() and
      tag = "resolved" and
      element = ref.toString() and
      location = ref.getLocation()
    )
  }
}

import MakeTest<InlinePoorMansFunctionResolutionTest>
