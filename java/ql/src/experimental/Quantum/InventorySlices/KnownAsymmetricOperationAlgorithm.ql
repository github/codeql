/**
 * @name Detects operations where the algorithm applied is a known asymmetric algorithms
 * @id java/crypto_inventory_slices/known_asymmetric_operation_algorithm
 * @kind problem
 */

import java
import experimental.quantum.Language

from Crypto::OperationNode op, Crypto::AlgorithmNode a
where a = op.getAKnownAlgorithm() and Crypto::isKnownAsymmetricAlgorithm(a)
select op, "Operation using asymmetric algorithm $@", a, a.getAlgorithmName()
