/**
 * @name Unknown algorithm from remote or external source
 * @description Detects cryptographic operations where the algorithm comes from a remote, external, or unknown source.
 * @id java/quantum/examples/demo/unknown-algorithm-remote-source
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::OperationNode op, Crypto::GenericSourceNode src, string sourceKind
where
  src = op.getAnAlgorithmOrGenericSource() and
  (
    src.getInternalType() = "RemoteData" and sourceKind = "remote data source"
    or
    src.getInternalType() = "Parameter" and sourceKind = "unreferenced parameter"
    or
    src.getInternalType() = "ExternalCall" and sourceKind = "external call"
    or
    src.getInternalType() = "LocalData" and sourceKind = "local data source"
  )
select op, "Operation uses algorithm from " + sourceKind + ": $@.", src, src.toString()
