import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.typetracking.internal.TypeTrackingImpl

private module ConsistencyChecksInput implements ConsistencyChecksInputSig {
  predicate unreachableNodeExclude(DataFlow::Node n) { n instanceof DataFlow::PostUpdateNode }
}

import ConsistencyChecks<ConsistencyChecksInput>
