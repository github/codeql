/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.new.FlowSummary
import TestFlow::PathGraph
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.FlowSummaryImpl
import semmle.python.ApiGraphs
import utils.test.dataflow.testTaintConfig
private import TestSummaries

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlow(s, _, _) or sc.propagatesFlow(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

from TestFlow::PathNode source, TestFlow::PathNode sink
where TestFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
