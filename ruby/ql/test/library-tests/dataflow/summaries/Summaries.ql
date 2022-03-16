/**
 * @kind path-problem
 */

import ruby
import codeql.ruby.dataflow.FlowSummary
import DataFlow::PathGraph
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.internal.FlowSummaryImpl
import codeql.ruby.dataflow.internal.AccessPathSyntax
import codeql.ruby.frameworks.data.ModelsAsData

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
    output = "BlockArgument.Parameter[0]" and
    preservesValue = true
    or
    input = "BlockArgument.ReturnValue" and
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
        ";;Member[Foo].Method[blockArg].BlockArgument.Parameter[0].Method[preserveTaint];Argument[0];ReturnValue;taint",
        ";any;Method[matchedByName];Argument[0];ReturnValue;taint",
        ";any;Method[matchedByNameRcv];Receiver;ReturnValue;taint",
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

class Conf extends TaintTracking::Configuration {
  Conf() { this = "FlowSummaries" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().getExpr().(StringLiteral).getConstantValue().isString("taint")
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getMethodName() = "sink" and
      mc.getAnArgument() = sink.asExpr().getExpr()
    )
    or
    sink = ModelOutput::getASinkNode("test-sink").getARhs()
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
