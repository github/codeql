import javascript
import testUtilities.ConsistencyChecking

class Steps extends ModelInput::SummaryModelCsv {
  override predicate row(string row) {
    // package;type;path;input;output;kind
    row =
      [
        "testlib;;Member[preserveTaint];Argument[0];ReturnValue;taint",
        "testlib;;Member[taintIntoCallback];Argument[0];Argument[1..2].Parameter[0];taint",
        "testlib;;Member[preserveArgZeroAndTwo];Argument[0,2];ReturnValue;taint",
        "testlib;;Member[preserveAllButFirstArgument];Argument[1..];ReturnValue;taint",
        "testlib;;Member[preserveAllIfCall].Call;Argument[0..];ReturnValue;taint"
      ]
  }
}

class Sinks extends ModelInput::SinkModelCsv {
  override predicate row(string row) {
    // package;type;path;kind
    row =
      [
        "testlib;;Member[mySink].Argument[0];test-sink",
        "testlib;;Member[mySinkIfCall].Call.Argument[0];test-sink",
        "testlib;;Member[mySinkIfNew].NewCall.Argument[0];test-sink",
        "testlib;;Member[mySinkLast].Argument[N-1];test-sink",
        "testlib;;Member[mySinkSecondLast].Argument[N-2];test-sink",
        "testlib;;Member[mySinkTwoLast].Argument[N-1,N-2];test-sink",
        "testlib;;Member[mySinkTwoLastRange].Argument[N-2..N-1];test-sink",
        "testlib;;Member[mySinkExceptLast].Argument[0..N-2];test-sink",
        "testlib;;Member[mySinkIfArityTwo].WithArity[2].Argument[0];test-sink",
      ]
  }
}

class BasicTaintTracking extends TaintTracking::Configuration {
  BasicTaintTracking() { this = "BasicTaintTracking" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
    or
    sink = ModelOutput::getASinkNode("test-sink").getARhs()
  }
}

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  any(BasicTaintTracking tr).hasFlow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) {
  node = ModelOutput::getASinkNode(kind).getARhs()
}
