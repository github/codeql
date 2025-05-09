/**
 * @name Known cipher algorithms (slice)
 * @description Outputs known cipher algorithms.
 * @id java/quantum/slices/known-cipher-algorithm
 * @kind table
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

// TODO: should there be a cipher algorithm node?
from Crypto::KeyOperationAlgorithmNode a
where
  a.getAlgorithmType() instanceof Crypto::KeyOpAlg::AsymmetricCipherAlgorithm or
  a.getAlgorithmType() instanceof Crypto::KeyOpAlg::SymmetricCipherAlgorithm
select a, a.getAlgorithmName()
