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
        "generatedtest;Test;false;newWithElement;;;Argument[0];Element of ReturnValue;value",
        "generatedtest;Test;false;getMapKey2;;;MapKey of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapKey;;;Argument[0];MapKey of ReturnValue;value",
        "generatedtest;Test;false;getMapValue2;;;MapValue of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapValue;;;Argument[0];MapValue of ReturnValue;value",
        "generatedtest;Test;false;getTable_rowKey;;;SyntheticField[com.google.common.collect.Table.rowKey] of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithTable_rowKey;;;Argument[0];SyntheticField[com.google.common.collect.Table.rowKey] of ReturnValue;value",
        "generatedtest;Test;false;getTable_columnKey;;;SyntheticField[com.google.common.collect.Table.columnKey] of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithTable_columnKey;;;Argument[0];SyntheticField[com.google.common.collect.Table.columnKey] of ReturnValue;value",
        "generatedtest;Test;false;newWithMapDifference_left;;;Argument[0];SyntheticField[com.google.common.collect.MapDifference.left] of ReturnValue;value",
        "generatedtest;Test;false;getMapDifference_left;;;SyntheticField[com.google.common.collect.MapDifference.left] of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapDifference_right;;;Argument[0];SyntheticField[com.google.common.collect.MapDifference.right] of ReturnValue;value",
        "generatedtest;Test;false;getMapDifference_right;;;SyntheticField[com.google.common.collect.MapDifference.right] of Argument[0];ReturnValue;value"
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

  override int fieldFlowBranchLimit() { result = 10 }
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
