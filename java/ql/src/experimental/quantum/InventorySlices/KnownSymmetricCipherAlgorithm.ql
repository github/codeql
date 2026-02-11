/**
 * @name Known symmetric cipher algorithms (slice)
 * @description Outputs known symmetric cipher algorithms.
 * @id java/quantum/slices/known-symmetric-cipher-algorithm
 * @kind table
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::KeyOperationAlgorithmNode a
where a.getAlgorithmType() instanceof Crypto::KeyOpAlg::SymmetricCipherAlgorithmType
select a, a.getAlgorithmName()
