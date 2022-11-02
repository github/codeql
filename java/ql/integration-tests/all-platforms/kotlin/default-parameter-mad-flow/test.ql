import java
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest
private import semmle.code.java.dataflow.ExternalFlow

private class Models extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";ConstructorWithDefaults;true;ConstructorWithDefaults;(int,int);;Argument[0];Argument[-1];taint;manual",
        ";LibKt;true;topLevelWithDefaults;(int,int);;Argument[0];ReturnValue;value;manual",
        ";LibKt;true;extensionWithDefaults;(String,int,int);;Argument[1];ReturnValue;value;manual",
        ";LibClass;true;memberWithDefaults;(int,int);;Argument[0];ReturnValue;value;manual",
        ";LibClass;true;extensionMemberWithDefaults;(String,int,int);;Argument[1];ReturnValue;value;manual",
        ";LibClass;true;multiParameterTest;(int,int,int,int);;Argument[0..1];ReturnValue;value;manual",
        ";LibClass;true;multiParameterExtensionTest;(int,int,int,int);;Argument[0, 1];ReturnValue;value;manual",
      ]
  }
}

private class SourceModels extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";LibKt;true;topLevelArgSource;(SomeToken,int);;Argument[0];kotlinMadFlowTest;manual",
        ";LibKt;true;extensionArgSource;(String,SomeToken,int);;Argument[1];kotlinMadFlowTest;manual",
        ";SourceClass;true;memberArgSource;(SomeToken,int);;Argument[0];kotlinMadFlowTest;manual"
      ]
  }
}

private class SinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";SinkClass;true;SinkClass;(int,int);;Argument[0];kotlinMadFlowTest;manual",
        ";LibKt;true;topLevelSink;(int,int);;Argument[0];kotlinMadFlowTest;manual",
        ";LibKt;true;extensionSink;(String,int,int);;Argument[1];kotlinMadFlowTest;manual",
        ";SinkClass;true;memberSink;(int,int);;Argument[0];kotlinMadFlowTest;manual",
        ";SinkClass;true;extensionMemberSink;(String,int,int);;Argument[1];kotlinMadFlowTest;manual"
      ]
  }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getCallee().getName() = "source"
    or
    sourceNode(n, "kotlinMadFlowTest")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
    or
    sinkNode(n, "kotlinMadFlowTest")
  }
}

class InlineFlowTest extends InlineExpectationsTest {
  InlineFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "flow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flow" and
    exists(DataFlow::Node src, DataFlow::Node sink, Config c | c.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
