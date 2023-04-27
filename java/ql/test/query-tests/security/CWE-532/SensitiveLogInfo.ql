import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.SensitiveLoggingQuery

class HasFlowTest extends InlineFlowTest {
  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    SensitiveLoggerFlow::flow(src, sink)
  }

  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }
}
