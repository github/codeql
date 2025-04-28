/**
 * @name Detects known uses of asymmetric algorithms
 * @id java/crypto_inventory_slices/known_asymmetric_algorithm
 * @kind problem
 */

import java
import experimental.Quantum.Language

from Crypto::AlgorithmNode a
where Crypto::isAsymmetricAlgorithm(a)
select a, "Instance of asymmetric algorithm " + a.getAlgorithmName()
