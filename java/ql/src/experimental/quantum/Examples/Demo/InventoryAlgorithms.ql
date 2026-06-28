/**
 * @name Inventory of cryptographic algorithms
 * @description Lists all detected key operation algorithms with their security classification.
 * @id java/quantum/examples/demo/inventory-algorithms
 * @kind problem
 * @problem.severity recommendation
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::AlgorithmNode alg, string name, string classification
where
  exists(Crypto::KeyOperationAlgorithmNode keyAlg |
    keyAlg = alg and
    name = keyAlg.getAlgorithmName() and
    classification = classifyAlgorithmType(keyAlg.getAlgorithmType())
  )
  or
  exists(Crypto::KeyAgreementAlgorithmNode kaAlg |
    kaAlg = alg and
    name = kaAlg.getAlgorithmName() and
    classification = classifyKeyAgreementType(kaAlg.getKeyAgreementType())
  )
select alg, "Algorithm: " + name + " [" + classification + "]."
