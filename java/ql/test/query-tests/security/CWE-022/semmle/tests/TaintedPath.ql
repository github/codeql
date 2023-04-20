import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.TaintedPathQuery

class HasFlowTest extends InlineFlowTest {
  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    TaintedPathFlow::flow(src, sink)
  }

  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }
}
