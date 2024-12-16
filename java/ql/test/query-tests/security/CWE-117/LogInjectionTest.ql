import java
import semmle.code.java.security.LogInjectionQuery
import utils.test.InlineFlowTest

private class TestSource extends RemoteFlowSource {
  TestSource() { this.asExpr().(MethodCall).getMethod().hasName("source") }

  override string getSourceType() { result = "test source" }
}

import TaintFlowTest<LogInjectionConfig>
