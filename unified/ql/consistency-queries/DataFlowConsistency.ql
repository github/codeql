private import unified
private import codeql.unified.internal.dataflow.AllDataFlow
private import codeql.dataflow.internal.DataFlowImplConsistency

module ConsistencyInput implements InputSig<Location, DataFlowInput> { }

module ConsistencyOutput =
  MakeConsistency<Location, DataFlowInput, TaintTrackingInput, ConsistencyInput>;

import ConsistencyOutput
