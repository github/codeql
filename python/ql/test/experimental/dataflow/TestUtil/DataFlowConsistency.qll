import python
import semmle.python.dataflow.new.DataFlow::DataFlow
import semmle.python.dataflow.new.internal.DataFlowPrivate
import semmle.python.dataflow.new.internal.DataFlowImplConsistency::Consistency

// TODO: this should be promoted to be a REAL consistency query by being placed in
// `python/ql/consistency-queries`. For for now it resides here.
private class MyConsistencyConfiguration extends ConsistencyConfiguration {
  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    exists(ArgumentPosition apos | n.argumentOf(_, apos) and apos.isStarArgs(_))
    or
    exists(ArgumentPosition apos | n.argumentOf(_, apos) and apos.isDictSplat())
  }

  override predicate reverseReadExclude(Node n) {
    // since `self`/`cls` parameters can be marked as implicit argument to `super()`,
    // they will have PostUpdateNodes. We have a read-step from the synthetic `**kwargs`
    // parameter, but dataflow-consistency queries should _not_ complain about there not
    // being a post-update node for the synthetic `**kwargs` parameter.
    n instanceof SynthDictSplatParameterNode
  }

  override predicate uniqueParameterNodeAtPositionExclude(
    DataFlowCallable c, ParameterPosition pos, Node p
  ) {
    // TODO: This can be removed once we solve the overlap of dictionary splat parameters
    c.getParameter(pos) = p and
    pos.isDictSplat() and
    not exists(p.getLocation().getFile().getRelativePath())
  }
}
