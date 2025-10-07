/**
 * @name Operations with unknown algorithm
 * @description Outputs operations where the algorithm applied is unknown
 * @id java/quantum/slices/operation-with-unknown-algorithm
 * @kind problem
 * @severity info
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

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
