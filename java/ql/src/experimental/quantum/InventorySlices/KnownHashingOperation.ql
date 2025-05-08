/**
 * @name Detects uses of hashing operations (operations exlicitly for hashing only, irrespective of the algorithm used)
 * @id java/crypto_inventory_slices/known_hashing_operation
 * @kind table
 */

import java
import experimental.quantum.Language

from Crypto::HashOperationNode op
select op, "Known hashing operation"
