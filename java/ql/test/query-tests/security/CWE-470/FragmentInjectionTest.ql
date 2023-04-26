import java
import semmle.code.java.security.FragmentInjectionQuery
import TestUtilities.InlineFlowTest

class Test extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    FragmentInjectionTaintFlow::flow(src, sink)
  }
}
