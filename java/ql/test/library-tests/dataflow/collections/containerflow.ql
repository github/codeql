import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import TestUtilities.InlineExpectationsTest
import DataFlow

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        ";B;false;readElement;(Spliterator);;Element of Argument[0];ReturnValue;value",
        ";B;false;readElement;(Stream);;Element of Argument[0];ReturnValue;value"
      ]
  }
}

class ContainerFlowConf extends Configuration {
  ContainerFlowConf() { this = "qltest:ContainerFlowConf" }

  override predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("source") }

  override predicate isSink(Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "hasValueFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(Node src, Node sink, ContainerFlowConf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
