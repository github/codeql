import python
import semmle.python.frameworks.data.internal.AccessPathSyntax as AccessPathSyntax
import semmle.python.frameworks.data.ModelsAsData
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow

// TODO:
/*
 * class Steps extends ModelInput::SummaryModelCsv {
 *  override predicate row(string row) {
 *    // package;type;path;input;output;kind
 *    row =
 *      [
 *        "testlib;;Member[preserveTaint];Argument[0];ReturnValue;taint",
 *        "testlib;;Member[taintIntoCallback];Argument[0];Argument[1..2].Parameter[0];taint",
 *        "testlib;;Member[taintIntoCallbackThis];Argument[0];Argument[1..2].Parameter[this];taint",
 *        "testlib;;Member[preserveArgZeroAndTwo];Argument[0,2];ReturnValue;taint",
 *        "testlib;;Member[preserveAllButFirstArgument];Argument[1..];ReturnValue;taint",
 *        "testlib;;Member[preserveAllIfCall].Call;Argument[0..];ReturnValue;taint",
 *        "testlib;;Member[getSource].ReturnValue.Member[continue];Argument[this];ReturnValue;taint",
 *      ]
 *  }
 * }
 */

class Sinks extends ModelInput::SinkModelCsv {
  override predicate row(string row) {
    // package;type;path;kind
    row = ["testlib;;Member[mySink].Argument[0];test-sink"]
  }
}

// TODO: Test taint steps (include that the base path may end with ".Call")
// TODO: Ctrl + f: TODO
// TODO: // There are no API-graph edges for: ArrayElement, Element, MapKey, MapValue (remove from valid tokens list)
// TODO: Verify that the list of valid tokens matches the implementation.
class Sources extends ModelInput::SourceModelCsv {
  // package;type;path;kind
  override predicate row(string row) {
    row = ["testlib;;Member[getSource].ReturnValue;test-source"]
  }
}

class BasicTaintTracking extends TaintTracking::Configuration {
  BasicTaintTracking() { this = "BasicTaintTracking" }

  override predicate isSource(DataFlow::Node source) {
    source = ModelOutput::getASourceNode("test-source").getAnImmediateUse()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = ModelOutput::getASinkNode("test-sink").getARhs()
  }
}

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  any(BasicTaintTracking tr).hasFlow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) {
  node = ModelOutput::getASinkNode(kind).getARhs()
}

query predicate isSource(DataFlow::Node node, string kind) {
  node = ModelOutput::getASourceNode(kind).getAnImmediateUse()
}

class SyntaxErrorTest extends ModelInput::SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "testlib;;Member[foo],Member[bar];test-sink", "testlib;;Member[foo] Member[bar];test-sink",
        "testlib;;Member[foo]. Member[bar];test-sink",
        "testlib;;Member[foo], Member[bar];test-sink",
        "testlib;;Member[foo]..Member[bar];test-sink",
        "testlib;;Member[foo] .Member[bar];test-sink", "testlib;;Member[foo]Member[bar];test-sink",
        "testlib;;Member[foo;test-sink", "testlib;;Member[foo]];test-sink",
        "testlib;;Member[foo]].Member[bar];test-sink"
      ]
  }
}

query predicate syntaxErrors(AccessPathSyntax::AccessPath path) { path.hasSyntaxError() }

query predicate warning = ModelOutput::getAWarning/0;
