import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.TaintedEnvironmentVariableQuery
import utils.test.InlineFlowTest

private class TestSource extends RemoteFlowSource {
  TestSource() { this.asExpr().(MethodCall).getMethod().hasName("source") }

  override string getSourceType() { result = "test source" }
}

import TaintFlowTest<ExecTaintedEnvironmentConfig>
