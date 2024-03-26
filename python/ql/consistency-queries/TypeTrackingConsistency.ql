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
    exists(DataFlow::Node m |
      m.asCfgNode().getNode() instanceof MatchCapturePattern
      or
      m.asCfgNode().getNode() instanceof MatchAsPattern
      or
      m.asCfgNode().getNode() instanceof MatchOrPattern
    |
      TypeTrackingInput::simpleLocalSmallStep*(m, n)
    )
    or
    // TODO: when adding support for proper content, handle iterable unpacking better
    // such as `for k,v in items:`, or `a, (b,c) = ...`
    n instanceof DataFlow::IterableSequenceNode
    or
    // We have missing use-use flow in
    // https://github.com/python/cpython/blob/0fb18b02c8ad56299d6a2910be0bab8ad601ef24/Lib/socketserver.py#L276-L303
    // which I couldn't just fix. We ignore the problems here, and instead rely on the
    // test-case added in https://github.com/github/codeql/pull/15841
    n.getLocation().getFile().getAbsolutePath().matches("%/socketserver.py")
  }
}

import ConsistencyChecks<ConsistencyChecksInput>
