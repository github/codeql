/**
 * @name Detects operations where the algorithm applied is a known hashing algorithm
 * @id java/crypto_inventory_slices/operation_with_known_hashing_algorithm
 * @kind problem
 */

import java
import experimental.Quantum.Language

from Crypto::OperationNode op, Crypto::HashAlgorithmNode a
where a = op.getAKnownAlgorithm()
select op, "Operation using hashing algorithm $@", a, a.getAlgorithmName()
