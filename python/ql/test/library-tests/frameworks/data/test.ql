import python
import semmle.python.dataflow.new.internal.AccessPathSyntax as AccessPathSyntax
import semmle.python.frameworks.data.ModelsAsData
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

class Steps extends ModelInput::SummaryModelCsv {
  override predicate row(string row) {
    // type;path;input;output;kind
    row =
      [
        "testlib;Member[Steps].Member[preserveTaint].Call;Argument[0];ReturnValue;taint",
        "testlib;Member[Steps].Member[taintIntoCallback];Argument[0];Argument[1..2].Parameter[0];taint",
        "testlib;Member[Steps].Member[preserveArgZeroAndTwo];Argument[0,2];ReturnValue;taint",
        "testlib;Member[Steps].Member[preserveAllButFirstArgument].Call;Argument[1..];ReturnValue;taint",
      ]
  }
}

class Types extends ModelInput::TypeModelCsv {
  override predicate row(string row) {
    // type1;type2;path
    row =
      [
        "testlib.Alias;testlib;Member[alias].ReturnValue",
        "testlib.Alias;testlib.Alias;Member[chain].ReturnValue",
      ]
  }
}

class Sinks extends ModelInput::SinkModelCsv {
  override predicate row(string row) {
    // type;path;kind
    row =
      [
        "testlib;Member[mySink].Argument[0,sinkName:];test-sink",
        // testing argument syntax
        "testlib;Member[Args].Member[arg0].Argument[0];test-sink", //
        "testlib;Member[Args].Member[arg1to3].Argument[1..3];test-sink", //
        "testlib;Member[Args].Member[lastarg].Argument[N-1];test-sink", //
        "testlib;Member[Args].Member[nonFist].Argument[1..];test-sink", //
        // callsite filter.
        "testlib;Member[CallFilter].Member[arityOne].WithArity[1].Argument[any];test-sink", //
        "testlib;Member[CallFilter].Member[twoOrMore].WithArity[2..].Argument[0..];test-sink", //
        // testing non-positional arguments
        "testlib;Member[ArgPos].Instance.Member[self_thing].Argument[self];test-sink", //
        // any argument
        "testlib;Member[ArgPos].Member[anyParam].Argument[any];test-sink", //
        "testlib;Member[ArgPos].Member[anyNamed].Argument[any-named];test-sink", //
        // testing package syntax
        "foo1.bar;Member[baz1].Argument[any];test-sink", //
        "foo2;Member[bar].Member[baz2].Argument[any];test-sink", //
      ]
  }
}

class Sources extends ModelInput::SourceModelCsv {
  // type;path;kind
  override predicate row(string row) {
    row =
      [
        "testlib;Member[getSource].ReturnValue;test-source", //
        "testlib.Alias;;test-source",
        // testing parameter syntax
        "testlib;Member[Callbacks].Member[first].Argument[0].Parameter[0];test-source", //
        "testlib;Member[Callbacks].Member[param1to3].Argument[0].Parameter[1..3];test-source", //
        "testlib;Member[Callbacks].Member[nonFirst].Argument[0].Parameter[1..];test-source", //
        // Common tokens.
        "testlib;Member[CommonTokens].Member[makePromise].ReturnValue.Awaited;test-source", //
        "testlib;Member[CommonTokens].Member[Class].Instance;test-source", //
        "testlib;Member[CommonTokens].Member[Super].Subclass.Instance;test-source", //
        // method
        "testlib;Member[CommonTokens].Member[Class].Instance.Method[foo];test-source", //
        // testing non-positional arguments
        "testlib;Member[ArgPos].Member[MyClass].Subclass.Member[foo].Parameter[self];test-source", //
        "testlib;Member[ArgPos].Member[MyClass].Subclass.Member[foo].Parameter[named:];test-source", //
        "testlib;Member[ArgPos].Member[MyClass].Subclass.Member[secondAndAfter].Parameter[1..];test-source", //
        "testlib;Member[ArgPos].Member[MyClass].Subclass.Member[otherSelfTest].Parameter[0];test-source", //
        "testlib;Member[ArgPos].Member[MyClass].Subclass.Member[anyParam].Parameter[any];test-source", //
        "testlib;Member[ArgPos].Member[MyClass].Subclass.Member[anyNamed].Parameter[any-named];test-source", //
      ]
  }
}

class BasicTaintTracking extends TaintTracking::Configuration {
  BasicTaintTracking() { this = "BasicTaintTracking" }

  override predicate isSource(DataFlow::Node source) {
    source = ModelOutput::getASourceNode("test-source").asSource()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = ModelOutput::getASinkNode("test-sink").asSink()
  }
}

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  any(BasicTaintTracking tr).hasFlow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) {
  node = ModelOutput::getASinkNode(kind).asSink()
}

query predicate isSource(DataFlow::Node node, string kind) {
  node = ModelOutput::getASourceNode(kind).asSource()
}

class SyntaxErrorTest extends ModelInput::SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "testlib;Member[foo],Member[bar];test-sink", //
        "testlib;Member[foo] Member[bar];test-sink", //
        "testlib;Member[foo]. Member[bar];test-sink", //
        "testlib;Member[foo], Member[bar];test-sink", //
        "testlib;Member[foo]..Member[bar];test-sink", //
        "testlib;Member[foo] .Member[bar];test-sink", //
        "testlib;Member[foo]Member[bar];test-sink", //
        "testlib;Member[foo;test-sink", //
        "testlib;Member[foo]];test-sink", //
        "testlib;Member[foo]].Member[bar];test-sink", //
      ]
  }
}

query predicate syntaxErrors(AccessPathSyntax::AccessPath path) { path.hasSyntaxError() }

query predicate warning = ModelOutput::getAWarning/0;
