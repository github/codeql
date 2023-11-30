import python
import semmle.python.dataflow.new.FlowSummary
import semmle.python.dataflow.new.internal.FlowSummaryImpl

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlowExt(s, _, _) or sc.propagatesFlowExt(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}
