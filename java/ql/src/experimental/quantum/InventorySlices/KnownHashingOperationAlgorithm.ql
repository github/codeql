/**
 * @name Operations using known hashing algorithms (slice)
 * @description Outputs operations where the algorithm used is a known hashing algorithm.
 * @id java/quantum/slices/operation-with-known-hashing-algorithm
 * @kind table
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::OperationNode op, Crypto::HashAlgorithmNode a
where a = op.getAKnownAlgorithm()
select op, a.getAlgorithmName()
