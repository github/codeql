import java
import TestUtilities.InlineExpectationsTest
import TestUtilities.InlineFlowTest
import semmle.code.java.security.RsaWithoutOaepQuery

class HasFlowTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    RsaWithoutOaepFlow::flow(src, sink)
  }
}
