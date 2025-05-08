/**
 * @name Detects known key derivation algorithms
 * @id java/crypto_inventory_slices/known_key_derivation_algorithm
 * @kind table
 */

import java
import experimental.quantum.Language

from Crypto::KeyDerivationAlgorithmNode alg
select alg, "Known key derivation algorithm " + alg.getAlgorithmName()
