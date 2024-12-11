import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest
import utils.test.InlineFlowTest

module ValueFlow = DataFlow::Global<DefaultFlowConfig>;

module PromotedMethodsTest implements TestSig {
  string getARelevantTag() { result = "promotedmethods" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink | ValueFlow::flow(source, sink) |
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sink.toString() and
      value = source.getEnclosingCallable().getName() and
      tag = "promotedmethods"
    )
  }
}

import MakeTest<PromotedMethodsTest>
