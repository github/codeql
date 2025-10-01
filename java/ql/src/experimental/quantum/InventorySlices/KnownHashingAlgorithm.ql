/**
 * @name Known hashing algorithms (slice)
 * @description Outputs known hashing algorithms.
 * @id java/quantum/slices/known-hashing-algorithm
 * @kind problem
 * @severity recommendation
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::HashAlgorithmNode a
select a, a.getAlgorithmName()
