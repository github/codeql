private import unified
private import codeql.unified.internal.dataflow.AllDataFlow
private import codeql.dataflow.internal.DataFlowImplConsistency

module ConsistencyInput implements InputSig<Location, DataFlowInput> {
  predicate argHasPostUpdateExclude(DataFlowInput::ArgumentNode n) {
    not exists(n.getBasicBlock()) // ignore unreachable data flow nodes
  }
}

module ConsistencyOutput =
  MakeConsistency<Location, DataFlowInput, TaintTrackingInput, ConsistencyInput>;

import ConsistencyOutput
