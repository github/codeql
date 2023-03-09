import java
import semmle.code.java.security.LogInjectionQuery
import TestUtilities.InlineFlowTest

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

private class TestSource extends RemoteFlowSource {
  TestSource() { this.asExpr().(MethodAccess).getMethod().hasName("source") }

  override string getSourceType() { result = "test source" }
}

private class LogInjectionTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override TaintTracking::Configuration getTaintFlowConfig() {
    result instanceof LogInjectionConfiguration
  }
}
