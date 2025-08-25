/**
 * @name Operations using known key derivation algorithms (slice)
 * @description Outputs operations where the algorithm used is a known key derivation algorithm.
 * @id java/quantum/slices/operation-with-known-kdf-algorithm
 * @kind table
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::OperationNode op, Crypto::KeyDerivationAlgorithmNode a
where a = op.getAKnownAlgorithm()
select op, a.getAlgorithmName()
