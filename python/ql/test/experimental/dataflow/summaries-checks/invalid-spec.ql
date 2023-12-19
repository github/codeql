import python
import semmle.python.dataflow.new.FlowSummary
import semmle.python.dataflow.new.internal.FlowSummaryImpl

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlow(s, _, _) or sc.propagatesFlow(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}
