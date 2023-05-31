import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

class SinkTest extends InlineExpectationsTest {
  SinkTest() { this = "SinkTest" }

  override string getARelevantTag() { result = "isSink" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "isSink" and
    exists(DataFlow::Node sink |
      sinkNode(sink, _) and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

class NeutralSinkTest extends InlineExpectationsTest {
  NeutralSinkTest() { this = "NeutralSinkTest" }

  override string getARelevantTag() { result = "isNeutralSink" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "isNeutralSink" and
    exists(Call call, Callable callable |
      call.getCallee() = callable and
      neutralModel(callable.getDeclaringType().getCompilationUnit().getPackage().getName(),
        callable.getDeclaringType().getSourceDeclaration().nestedName(), callable.getName(),
        [paramsString(callable), ""], "sink", _) and
      call.getLocation() = location and
      element = call.toString() and
      value = ""
    )
  }
}
