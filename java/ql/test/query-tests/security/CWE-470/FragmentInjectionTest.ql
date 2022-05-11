import java
import semmle.code.java.security.FragmentInjectionQuery
import TestUtilities.InlineFlowTest

class Test extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override TaintTracking::Configuration getTaintFlowConfig() {
    result instanceof FragmentInjectionTaintConf
  }
}
