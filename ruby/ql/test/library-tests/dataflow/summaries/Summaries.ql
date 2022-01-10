/**
 * @kind path-problem
 */

import ruby
import codeql.ruby.dataflow.FlowSummary
import DataFlow::PathGraph
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.internal.FlowSummaryImpl

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlowExt(s, _, _) or sc.propagatesFlowExt(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

query predicate invalidOutputSpecComponent(SummarizedCallable sc, string s, string c) {
  sc.propagatesFlowExt(_, s, _) and
  Private::External::specSplit(s, c, _) and
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
    output = "Parameter[0] of BlockArgument" and
    preservesValue = true
    or
    input = "ReturnValue of BlockArgument" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableApplyLambda extends SummarizedCallable {
  SummarizedCallableApplyLambda() { this = "apply_lambda" }

  override MethodCall getACall() { result.getMethodName() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[1]" and
    output = "Parameter[0] of Argument[0]" and
    preservesValue = true
    or
    input = "ReturnValue of Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

class Conf extends TaintTracking::Configuration {
  Conf() { this = "FlowSummaries" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().getExpr().(StringLiteral).getValueText() = "taint"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getMethodName() = "sink" and
      mc.getAnArgument() = sink.asExpr().getExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
