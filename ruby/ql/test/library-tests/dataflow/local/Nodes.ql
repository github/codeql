import ruby
import codeql.ruby.dataflow.internal.DataFlowPrivate
import codeql.ruby.dataflow.internal.DataFlowDispatch

query predicate ret(ReturningNode node) { any() }

query predicate arg(ArgumentNode n, DataFlowCall call, int pos) { n.argumentOf(call, pos) }
