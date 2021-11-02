import java
import semmle.code.java.security.LogInjectionQuery
import TestUtilities.InlineFlowTest

private class LogInjectionTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override TaintTracking::Configuration getTaintFlowConfig() {
    result instanceof LogInjectionConfiguration
  }
}
