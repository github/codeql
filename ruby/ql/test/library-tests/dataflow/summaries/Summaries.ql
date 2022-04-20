/**
 * @kind path-problem
 */

import ruby
import codeql.ruby.dataflow.FlowSummary
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.internal.FlowSummaryImpl
import codeql.ruby.dataflow.internal.AccessPathSyntax
import codeql.ruby.frameworks.data.ModelsAsData
import TestUtilities.InlineFlowTest
import DataFlow::PathGraph

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlowExt(s, _, _) or sc.propagatesFlowExt(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

query predicate warning = ModelOutput::getAWarning/0;

query predicate invalidOutputSpecComponent(SummarizedCallable sc, AccessPath s, AccessPathToken c) {
  sc.propagatesFlowExt(_, s, _) and
  c = s.getToken(_) and
  c = "ArrayElement" // not allowed in output specs; use `ArrayElement[?] instead
}

private class SummarizedCallableIdentity extends SummarizedCallable {
  SummarizedCallableIdentity() { this = "identity" }

  override MethodCall getACall() { result.getMethodName() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableApplyBlock extends SummarizedCallable {
  SummarizedCallableApplyBlock() { this = "apply_block" }

  override MethodCall getACall() { result.getMethodName() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "Argument[block].Parameter[0]" and
    preservesValue = true
    or
    input = "Argument[block].ReturnValue" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableApplyLambda extends SummarizedCallable {
  SummarizedCallableApplyLambda() { this = "apply_lambda" }

  override MethodCall getACall() { result.getMethodName() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[1]" and
    output = "Argument[0].Parameter[0]" and
    preservesValue = true
    or
    input = "Argument[0].ReturnValue" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class StepsFromModel extends ModelInput::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;Member[Foo].Method[firstArg];Argument[0];ReturnValue;taint",
        ";;Member[Foo].Method[secondArg];Argument[1];ReturnValue;taint",
        ";;Member[Foo].Method[onlyWithoutBlock].WithoutBlock;Argument[0];ReturnValue;taint",
        ";;Member[Foo].Method[onlyWithBlock].WithBlock;Argument[0];ReturnValue;taint",
        ";;Member[Foo].Method[blockArg].Argument[block].Parameter[0].Method[preserveTaint];Argument[0];ReturnValue;taint",
        ";;Member[Foo].Method[namedArg];Argument[foo:];ReturnValue;taint",
        ";;Member[Foo].Method[anyArg];Argument[any];ReturnValue;taint",
        ";;Member[Foo].Method[anyPositionFromOne];Argument[1..];ReturnValue;taint",
        ";;Member[Foo].Method[intoNamedCallback];Argument[0];Argument[foo:].Parameter[0];taint",
        ";;Member[Foo].Method[intoNamedParameter];Argument[0];Argument[0].Parameter[foo:];taint",
        ";;Member[Foo].Method[startInNamedCallback].Argument[foo:].Parameter[0].Method[preserveTaint];Argument[0];ReturnValue;taint",
        ";;Member[Foo].Method[startInNamedParameter].Argument[0].Parameter[foo:].Method[preserveTaint];Argument[0];ReturnValue;taint",
        ";any;Method[matchedByName];Argument[0];ReturnValue;taint",
        ";any;Method[matchedByNameRcv];Argument[self];ReturnValue;taint",
      ]
  }
}

private class TypeFromModel extends ModelInput::TypeModelCsv {
  override predicate row(string row) {
    row =
      [
        "test;FooOrBar;;;Member[Foo].Instance", //
        "test;FooOrBar;;;Member[Bar].Instance", //
        "test;FooOrBar;test;FooOrBar;Method[next].ReturnValue",
      ]
  }
}

private class InvalidTypeModel extends ModelInput::TypeModelCsv {
  override predicate row(string row) {
    row =
      [
        "test;TooManyColumns;;;Member[Foo].Instance;too;many;columns", //
        "test;TooFewColumns", //
        "test;X;test;Y;Method[foo].Arg[0]", //
        "test;X;test;Y;Method[foo].Argument[0-1]", //
        "test;X;test;Y;Method[foo].Argument[*]", //
        "test;X;test;Y;Method[foo].Argument", //
        "test;X;test;Y;Method[foo].Member", //
      ]
  }
}

private class SinkFromModel extends ModelInput::SinkModelCsv {
  override predicate row(string row) { row = "test;FooOrBar;Method[method].Argument[0];test-sink" }
}

class CustomValueSink extends DefaultValueFlowConf {
  override predicate isSink(DataFlow::Node sink) {
    super.isSink(sink)
    or
    sink = ModelOutput::getASinkNode("test-sink").getARhs()
  }
}

class CustomTaintSink extends DefaultTaintFlowConf {
  override predicate isSink(DataFlow::Node sink) {
    super.isSink(sink)
    or
    sink = ModelOutput::getASinkNode("test-sink").getARhs()
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, DataFlow::Configuration conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
