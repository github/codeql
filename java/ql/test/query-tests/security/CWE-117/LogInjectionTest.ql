import java
import semmle.code.java.security.LogInjectionQuery
import TestUtilities.InlineFlowTest

private class TestSource extends RemoteFlowSource {
  TestSource() { this.asExpr().(MethodAccess).getMethod().hasName("source") }

  override string getSourceType() { result = "test source" }
}

private class LogInjectionTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    LogInjectionFlow::flow(src, sink)
  }
}
