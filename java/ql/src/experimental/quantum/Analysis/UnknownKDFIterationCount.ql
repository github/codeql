/**
 * @name Detects unknown KDf iteration counts
 * @id java/crypto_inventory_filters/unknown_kdf_iteration_count
 * @kind problem
 */

import java
import experimental.quantum.Language

from Crypto::KeyDerivationOperationNode op, Element e, string msg
where
  e = op.getIterationCount().asElement() and
  not e instanceof Literal and
  msg = "Key derivation operation with unknown iteration: $@"
  or
  not exists(op.getIterationCount()) and
  e = op.asElement() and
  msg = "Key derivation operation with no iteration configuration."
select op, msg, e, e.toString()
