import java
import semmle.code.java.security.AndroidSensitiveCommunicationQuery
import TestUtilities.InlineExpectationsTest
import TestUtilities.InlineFlowTest

class HasFlowTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    SensitiveCommunicationFlow::flow(src, sink)
  }
}
