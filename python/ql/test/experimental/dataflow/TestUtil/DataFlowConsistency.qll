import semmle.python.dataflow.new.DataFlow::DataFlow
import semmle.python.dataflow.new.internal.DataFlowPrivate
import semmle.python.dataflow.new.internal.DataFlowImplConsistency::Consistency

// TODO: this should be promoted to be a REAL consistency query by being placed in
// `python/ql/consistency-queries`. For for now it resides here.
private class MyConsistencyConfiguration extends ConsistencyConfiguration {
  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    exists(ArgumentPosition apos | n.argumentOf(_, apos) and apos.isDictSplat())
  }
}
