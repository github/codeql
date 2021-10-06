/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.new.FlowSummary
import DataFlow::PathGraph
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.FlowSummaryImpl

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlowExt(s, _, _) or sc.propagatesFlowExt(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

private class SummarizedCallableIdentity extends SummarizedCallable {
  SummarizedCallableIdentity() { this = "identity" }

  override Call getACall() { result.getFunc().(Name).getId() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

// For lambda flow to work, implement lambdaCall and lambdaCreation
private class SummarizedCallableApplyLambda extends SummarizedCallable {
  SummarizedCallableApplyLambda() { this = "apply_lambda" }

  override Call getACall() { result.getFunc().(Name).getId() = this }

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

private class SummarizedCallableMap extends SummarizedCallable {
  SummarizedCallableMap() { this = "map" }

  override Call getACall() { result.getFunc().(Name).getId() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "ListElement of Argument[1]" and
    output = "ListElement of Parameter[0] of Argument[0]" and
    preservesValue = true
    or
    input = "ReturnValue of Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

class Conf extends TaintTracking::Configuration {
  Conf() { this = "FlowSummaries" }

  override predicate isSource(DataFlow::Node src) { src.asExpr().(StrConst).getS() = "taint" }

  override predicate isSink(DataFlow::Node sink) {
    exists(Call mc |
      mc.getFunc().(Name).getId() = "sink" and
      mc.getAnArg() = sink.asExpr()
    )
  }
}

predicate propagates(
  SummarizedCallable sc, SummaryComponentStack input, SummaryComponentStack output,
  boolean preservesValue
) {
  sc.propagatesFlow(input, output, preservesValue)
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
