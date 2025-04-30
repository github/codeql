/**
 * @name Detects operations where the algorithm applied is unknown
 * @id java/crypto_inventory_slices/unknown_operation_algorithm
 * @kind problem
 */

import java
import experimental.Quantum.Language

//TODO: can we have an unknown node concept?
from Crypto::OperationNode op, Element e, string msg
where
  not exists(op.getAnAlgorithmOrGenericSource()) and
  e = op.asElement() and
  msg = "Operation with unconfigured algorithm (no known sources)."
  or
  exists(Crypto::GenericSourceNode n |
    n = op.getAnAlgorithmOrGenericSource() and
    e = n.asElement()
  ) and
  msg = "Operation with unknown algorithm source: $@"
select op, msg, e, e.toString()
