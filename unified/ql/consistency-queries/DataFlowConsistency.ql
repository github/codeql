private import unified
private import codeql.unified.internal.dataflow.AllDataFlow
private import codeql.dataflow.internal.DataFlowImplConsistency

module ConsistencyInput implements InputSig<Location, DataFlowInput> {
  predicate argHasPostUpdateExclude(DataFlowInput::ArgumentNode n) {
    not exists(n.getBasicBlock()) // ignore unreachable data flow nodes
  }

  predicate reverseReadExclude(DataFlow::Node n) {
    // When read steps are contributed by a language plugin we currently don't expect them to
    // have post-update nodes for reverse-reads.
    any(DataFlowPlugin p).step(n, any(Step s | s.read(_)), _)
  }

  predicate postWithInFlowExclude(DataFlow::Node n) {
    // In summaries, 'inout' parameters result in flow directly into the post-update node for an argument
    n instanceof TSummaryNode
  }
}

module ConsistencyOutput =
  MakeConsistency<Location, DataFlowInput, TaintTrackingInput, ConsistencyInput>;

import ConsistencyOutput
