/**
 * @name Detects known cipher algorithms
 * @id java/crypto_inventory_slices/known_cipher_algorithm
 * @kind problem
 */

import java
import experimental.quantum.Language

// TODO: should there be a cipher algorithm node?
from Crypto::KeyOperationAlgorithmNode a
where
  a.getAlgorithmType() instanceof Crypto::KeyOpAlg::AsymmetricCipherAlgorithm or
  a.getAlgorithmType() instanceof Crypto::KeyOpAlg::SymmetricCipherAlgorithm
select a, "Instance of cipher algorithm " + a.getAlgorithmName()
