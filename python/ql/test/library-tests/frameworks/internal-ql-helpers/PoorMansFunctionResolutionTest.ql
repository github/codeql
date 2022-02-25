private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
import TestUtilities.InlineExpectationsTest

class InlinePoorMansFunctionResolutionTest extends InlineExpectationsTest {
  InlinePoorMansFunctionResolutionTest() { this = "InlinePoorMansFunctionResolutionTest" }

  override string getARelevantTag() { result = "resolved" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Function func, DataFlow::Node ref |
      ref = poorMansFunctionTracker(func) and
      not ref.asExpr() instanceof FunctionExpr and
      // exclude things like `GSSA variable func`
      exists(ref.asExpr()) and
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
