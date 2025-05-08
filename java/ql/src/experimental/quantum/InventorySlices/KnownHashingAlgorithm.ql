/**
 * @name Detects algorithms that are known hashing algorithms
 * @id java/crypto_inventory_slices/known_hashing_algorithm
 * @kind table
 */

import java
import experimental.quantum.Language

from Crypto::HashAlgorithmNode a
select a, "Instance of hashing algorithm " + a.getAlgorithmName()
