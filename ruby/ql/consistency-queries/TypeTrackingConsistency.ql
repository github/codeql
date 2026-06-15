import codeql.ruby.DataFlow
import codeql.ruby.typetracking.internal.TypeTrackingImpl

private module ConsistencyChecksInput implements ConsistencyChecksInputSig {
  predicate unreachableNodeExclude(DataFlow::Node n) { n instanceof DataFlow::PostUpdateNode }
}

import ConsistencyChecks<ConsistencyChecksInput>
