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

  override predicate uniqueParameterNodePositionExclude(
    DataFlowCallable c, ParameterPosition pos, Node p
  ) {
    // For normal parameters that can both be passed as positional arguments or keyword
    // arguments, we currently have parameter positions for both cases..
    //
    // TODO: Figure out how bad breaking this consistency check is
    exists(Function func, Parameter param |
      c.getScope() = func and
      p = parameterNode(param) and
      c.getParameter(pos) = p and
      param = func.getArg(_) and
      param = func.getArgByName(_)
    )
  }

  override predicate uniqueCallEnclosingCallableExclude(DataFlowCall call) {
    not exists(call.getLocation().getFile().getRelativePath())
  }
}
