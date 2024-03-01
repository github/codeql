private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.dataflow.new.internal.TypeTrackingImpl

private module ConsistencyChecksInput implements ConsistencyChecksInputSig {
  predicate unreachableNodeExclude(DataFlow::Node n) {
    n instanceof DataFlowPrivate::SyntheticPostUpdateNode
    or
    n instanceof DataFlowPrivate::SyntheticPreUpdateNode
    or
    // TODO: when adding support for proper content, handle **kwargs passing better!
    n instanceof DataFlowPrivate::SynthDictSplatArgumentNode
    or
    // TODO: when adding support for proper content, handle unpacking tuples in match
    // cases better, such as
    //
    // match (NONSOURCE, SOURCE):
    //   case (x, y): ...
    exists(DataFlow::Node m | m.asCfgNode().getNode() instanceof MatchCapturePattern |
      TypeTrackingInput::simpleLocalSmallStep*(m, n)
    )
  }
}

import ConsistencyChecks<ConsistencyChecksInput>
