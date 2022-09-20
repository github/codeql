/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.new.FlowSummary
import DataFlow::PathGraph
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.FlowSummaryImpl
import semmle.python.ApiGraphs
import experimental.dataflow.testTaintConfig
private import TestSummaries

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlowExt(s, _, _) or sc.propagatesFlowExt(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TestConfiguration conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
