/**
 * @name Detects operations where the algorithm applied is a known key derivation algorithm
 * @id java/crypto_inventory_slices/operation_with_known_key_derivation_algorithm
 * @kind problem
 */

import java
import experimental.Quantum.Language

from Crypto::OperationNode op, Crypto::KeyDerivationAlgorithmNode a
where a = op.getAKnownAlgorithm()
select op, "Operation using key derivation algorithm $@", a, a.getAlgorithmName()
