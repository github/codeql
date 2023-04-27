import javascript
import testUtilities.ConsistencyChecking
import semmle.javascript.frameworks.data.internal.AccessPathSyntax as AccessPathSyntax

class Steps extends ModelInput::SummaryModelCsv {
  override predicate row(string row) {
    // type;path;input;output;kind
    row =
      [
        "testlib;Member[preserveTaint];Argument[0];ReturnValue;taint",
        "testlib;Member[taintIntoCallback];Argument[0];Argument[1..2].Parameter[0];taint",
        "testlib;Member[taintIntoCallbackThis];Argument[0];Argument[1..2].Parameter[this];taint",
        "testlib;Member[preserveArgZeroAndTwo];Argument[0,2];ReturnValue;taint",
        "testlib;Member[preserveAllButFirstArgument];Argument[1..];ReturnValue;taint",
        "testlib;Member[preserveAllIfCall].Call;Argument[0..];ReturnValue;taint",
        "testlib;Member[getSource].ReturnValue.Member[continue];Argument[this];ReturnValue;taint",
        "testlib.~HasThisFlow;;;Member[getThis].ReturnValue;type",
      ]
  }
}

class TypeDefs extends ModelInput::TypeModelCsv {
  override predicate row(string row) {
    row =
      [
        "testlib.~HasThisFlow;testlib;Member[typevar]",
        "testlib.~HasThisFlow;testlib.~HasThisFlow;Member[left,right,x]",
      ]
  }
}

class Sinks extends ModelInput::SinkModelCsv {
  override predicate row(string row) {
    // type;path;kind
    row =
      [
        "testlib;Member[mySink].Argument[0];test-sink",
        "testlib;Member[mySinkIfCall].Call.Argument[0];test-sink",
        "testlib;Member[mySinkIfNew].NewCall.Argument[0];test-sink",
        "testlib;Member[mySinkLast].Argument[N-1];test-sink",
        "testlib;Member[mySinkSecondLast].Argument[N-2];test-sink",
        "testlib;Member[mySinkTwoLast].Argument[N-1,N-2];test-sink",
        "testlib;Member[mySinkTwoLastRange].Argument[N-2..N-1];test-sink",
        "testlib;Member[mySinkExceptLast].Argument[0..N-2];test-sink",
        "testlib;Member[mySinkIfArityTwo].WithArity[2].Argument[0];test-sink",
        "testlib;Member[sink1, sink2, sink3 ].Argument[0];test-sink",
        "testlib;Member[ClassDecorator].DecoratedClass.Instance.Member[returnValueIsSink].ReturnValue;test-sink",
        "testlib;Member[FieldDecoratorSink].DecoratedMember;test-sink",
        "testlib;Member[MethodDecorator].DecoratedMember.ReturnValue;test-sink",
        "testlib;Member[MethodDecoratorWithArgs].ReturnValue.DecoratedMember.ReturnValue;test-sink",
        "testlib;Member[ParamDecoratorSink].DecoratedParameter;test-sink",
        "testlib;AnyMember.Member[memberSink].Argument[0];test-sink",
        "testlib;Member[overloadedSink].WithStringArgument[0=danger].Argument[1];test-sink",
        "testlib;Member[typevar].TypeVar[ABC].Member[mySink].Argument[0];test-sink",
        "testlib;Member[typevar].TypeVar[ABC].TypeVar[ABC].Member[mySink].Argument[1];test-sink",
        "testlib;Member[typevar].TypeVar[LeftRight].Member[mySink].Argument[0];test-sink",
      ]
  }
}

class TypeVars extends ModelInput::TypeVariableModelCsv {
  override predicate row(string row) {
    row =
      [
        "ABC;Member[a].Member[b].WithArity[0].ReturnValue.Member[c]", //
        "LeftRight;Member[left].TypeVar[LeftRight].Member[right]", //
        "LeftRight;Member[x]",
      ]
  }
}

class Sources extends ModelInput::SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "testlib;Member[getSource].ReturnValue;test-source",
        "testlib;Member[ClassDecorator].DecoratedClass.Instance.Member[inputIsSource].Parameter[0];test-source",
        "testlib;Member[FieldDecoratorSource].DecoratedMember;test-source",
        "testlib;Member[ParamDecoratorSource].DecoratedParameter;test-source",
        "testlib;Member[MethodDecorator].DecoratedMember.Parameter[0];test-source",
        "testlib;Member[MethodDecoratorWithArgs].ReturnValue.DecoratedMember.Parameter[0];test-source",
      ]
  }
}

class BasicTaintTracking extends TaintTracking::Configuration {
  BasicTaintTracking() { this = "BasicTaintTracking" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
    or
    source = ModelOutput::getASourceNode("test-source").asSource()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
    or
    sink = ModelOutput::getASinkNode("test-sink").asSink()
  }
}

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  any(BasicTaintTracking tr).hasFlow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) {
  node = ModelOutput::getASinkNode(kind).asSink()
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
        "testlib;Member[foo]].Member[bar];test-sink"
      ]
  }
}

query predicate syntaxErrors(AccessPathSyntax::AccessPath path) { path.hasSyntaxError() }

query predicate warning = ModelOutput::getAWarning/0;
