/**
 * @name Detects operations where the algorithm applied is a known key derivation algorithm
 * @id java/cryptography-inventory-slices/operation-known-key-derivation-algorithm
 * @description This query identifies operations that utilize a known key derivation algorithm.
 * @kind problem
 */

import java
import experimental.quantum.Language

from Crypto::OperationNode op, Crypto::KeyDerivationAlgorithmNode a
where a = op.getAKnownAlgorithm()
select op, "Operation using key derivation algorithm $@", a, a.getAlgorithmName()
