/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.new.FlowSummary
import DataFlow::PathGraph
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.FlowSummaryImpl
import semmle.python.ApiGraphs
private import TestSummaries

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlowExt(s, _, _) or sc.propagatesFlowExt(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

class Conf extends TaintTracking::Configuration {
  Conf() { this = "FlowSummaries" }

  override predicate isSource(DataFlow::Node src) { src.asExpr().(StrConst).getS() = "source" }

  override predicate isSink(DataFlow::Node sink) {
    exists(Call mc |
      mc.getFunc().(Name).getId() = "SINK" and
      mc.getAnArg() = sink.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
