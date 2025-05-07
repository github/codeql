/**
 * @name Detects known weak KDf iteration counts (less than 100k and the count is statically known)
 * @id java/crypto_inventory_filters/known_weak_kdf_iteration_count
 * @kind problem
 */

import java
import experimental.quantum.Language

from Crypto::KeyDerivationOperationNode op, Literal l
where
  op.getIterationCount().asElement() = l and
  l.getValue().toInt() < 100000
select op, "Key derivation operation configures iteration count below 100k: $@", l,
  l.getValue().toString()
