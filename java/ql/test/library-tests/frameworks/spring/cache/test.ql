import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;getMapKey;;;MapKey of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapKey;;;Argument[0];MapKey of ReturnValue;value",
        "generatedtest;Test;false;getMapValue;;;MapValue of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapValue;;;Argument[0];MapValue of ReturnValue;value"
      ]
  }
}

class ValueFlowConf extends DataFlow::Configuration {
  ValueFlowConf() { this = "qltest:valueFlowConf" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("source")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

class TaintFlowConf extends TaintTracking::Configuration {
  TaintFlowConf() { this = "qltest:taintFlowConf" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("source")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["hasValueFlow", "hasTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, ValueFlowConf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, TaintFlowConf conf |
      conf.hasFlow(src, sink) and not any(ValueFlowConf c).hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
