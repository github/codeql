private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.dataflow.new.internal.TypeTrackingImpl

private module ConsistencyChecksInput implements ConsistencyChecksInputSig {
  predicate unreachableNodeExclude(DataFlow::Node n) {
    n instanceof DataFlowPrivate::SyntheticPostUpdateNode
    or
    n instanceof DataFlowPrivate::SyntheticPreUpdateNode
  }
}

import ConsistencyChecks<ConsistencyChecksInput>
