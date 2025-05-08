/**
 * @name Detects operations where the algorithm applied is a known key derivation algorithm
 * @id java/crypto_inventory_slices/operation_known_key_derivation_algorithm
 * @kind table
 */

import java
import experimental.quantum.Language

from Crypto::OperationNode op, Crypto::KeyDerivationAlgorithmNode a
where a = op.getAKnownAlgorithm()
select op, "Operation using key derivation algorithm $@", a, a.getAlgorithmName()
