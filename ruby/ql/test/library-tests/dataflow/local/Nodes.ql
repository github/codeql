import ruby
import codeql.ruby.dataflow.internal.DataFlowPrivate
import codeql.ruby.dataflow.internal.DataFlowDispatch

query predicate ret(ReturningNode node) { any() }

query predicate arg(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
  n.argumentOf(call, pos) and
  not n instanceof SummaryNode
}
