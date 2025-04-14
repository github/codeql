import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineExpectationsTest

module SourceTest implements TestSig {
  string getARelevantTag() { result = "source" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "source" and
    exists(RemoteFlowSource source |
      not source.asParameter().getCallable().getDeclaringType().hasName("DefaultConsumer") and
      source.getLocation() = location and
      element = source.toString() and
      value = ""
    )
  }
}

import MakeTest<SourceTest>
