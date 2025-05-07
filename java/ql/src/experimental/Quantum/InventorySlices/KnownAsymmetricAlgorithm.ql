/**
 * @name Detects known asymmetric algorithms
 * @id java/crypto_inventory_slices/known_asymmetric_algorithm
 * @kind problem
 */

import java
import experimental.quantum.Language

from Crypto::AlgorithmNode a
where Crypto::isKnownAsymmetricAlgorithm(a)
select a, "Instance of asymmetric algorithm " + a.getAlgorithmName()
