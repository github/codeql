/**
 * @name Detects known asymmetric cipher algorithms
 * @id java/crypto_inventory_slices/known_asymmetric_cipher_algorithm
 * @kind table
 */

import java
import experimental.quantum.Language

from Crypto::KeyOperationAlgorithmNode a
where a.getAlgorithmType() instanceof Crypto::KeyOpAlg::AsymmetricCipherAlgorithm
select a, "Instance of asymmetric cipher algorithm " + a.getAlgorithmName()
