/**
 * @name Detects uses of key derivation operations (operations exlicitly for key derivation only, irrespective of the algorithm used)
 * @id java/crypto_inventory_slices/known_key_derivation_operation
 * @kind problem
 */

import java
import experimental.quantum.Language

from Crypto::KeyDerivationOperationNode op
select op, "Known key derivation operation"
