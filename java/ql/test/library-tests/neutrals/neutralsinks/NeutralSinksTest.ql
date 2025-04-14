import java
import utils.test.InlineExpectationsTest
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

module SinkTest implements TestSig {
  string getARelevantTag() { result = "isSink" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "isSink" and
    exists(DataFlow::Node sink |
      sinkNode(sink, _) and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

module NeutralSinkTest implements TestSig {
  string getARelevantTag() { result = "isNeutralSink" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "isNeutralSink" and
    exists(Call call, Callable callable |
      call.getCallee() = callable and
      neutralModel(callable.getDeclaringType().getCompilationUnit().getPackage().getName(),
        callable.getDeclaringType().getSourceDeclaration().getNestedName(), callable.getName(),
        [paramsString(callable), ""], "sink", _) and
      call.getLocation() = location and
      element = call.toString() and
      value = ""
    )
  }
}

import MakeTest<MergeTests<SinkTest, NeutralSinkTest>>
