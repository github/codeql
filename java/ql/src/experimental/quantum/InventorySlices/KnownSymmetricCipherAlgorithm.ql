/**
 * @name Detects known symmetric cipher algorithms
 * @id java/crypto_inventory_slices/known_symmetric_cipher_algorithm
 * @kind table
 */

import java
import experimental.quantum.Language

from Crypto::KeyOperationAlgorithmNode a
where a.getAlgorithmType() instanceof Crypto::KeyOpAlg::SymmetricCipherAlgorithm
select a, "Instance of symmetric cipher algorithm " + a.getAlgorithmName()
