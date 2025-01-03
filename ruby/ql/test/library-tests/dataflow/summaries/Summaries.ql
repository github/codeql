/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.ApiGraphs
import codeql.ruby.dataflow.FlowSummary
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.internal.FlowSummaryImpl
import codeql.ruby.frameworks.data.ModelsAsData
import utils.test.InlineFlowTest
import PathGraph

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlow(s, _, _) or sc.propagatesFlow(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

query predicate warning = ModelOutput::getAWarning/0;

private class SummarizedCallableIdentity extends SummarizedCallable {
  SummarizedCallableIdentity() { this = "identity" }

  override MethodCall getACall() { result.getMethodName() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableApplyBlock extends SummarizedCallable {
  SummarizedCallableApplyBlock() { this = "apply_block" }

  override MethodCall getACall() { result.getMethodName() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[1]" and
    output = "Argument[0].Parameter[0]" and
    preservesValue = true
    or
    input = "Argument[0].ReturnValue" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class TypeFromCodeQL extends ModelInput::TypeModel {
  override DataFlow::Node getASource(string type) {
    type = "~FooOrBar" and
    result.getConstantValue().getString() = "magic_string"
  }

  override API::Node getAnApiNode(string type) {
    type = "~FooOrBar" and
    result = API::getTopLevelMember("Alias").getMember(["Foo", "Bar"])
  }
}

module CustomConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { DefaultFlowConfig::isSource(source) }

  predicate isSink(DataFlow::Node sink) {
    DefaultFlowConfig::isSink(sink)
    or
    sink = ModelOutput::getASinkNode("test-sink").asSink()
  }
}

import FlowTest<CustomConfig, CustomConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
