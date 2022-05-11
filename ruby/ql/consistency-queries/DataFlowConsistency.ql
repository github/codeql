import codeql.ruby.DataFlow::DataFlow
import codeql.ruby.dataflow.internal.DataFlowPrivate
import codeql.ruby.dataflow.internal.DataFlowImplConsistency::Consistency

private class MyConsistencyConfiguration extends ConsistencyConfiguration {
  override predicate postWithInFlowExclude(Node n) { n instanceof SummaryNode }

  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    n instanceof BlockArgumentNode
    or
    n instanceof SummaryNode
  }
}
