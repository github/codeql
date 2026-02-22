/**
 * @name Quantum-vulnerable algorithm
 * @description Detects use of cryptographic algorithms that are vulnerable to quantum computing attacks.
 * @id java/quantum/examples/demo/quantum-vulnerable-algorithm
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::AlgorithmNode alg, string msg
where
  exists(Crypto::KeyOperationAlgorithmNode keyAlg |
    keyAlg = alg and
    isQuantumVulnerableAlgorithmType(keyAlg.getAlgorithmType()) and
    msg =
      "Quantum-vulnerable key operation algorithm: " + keyAlg.getAlgorithmName() + "."
  )
  or
  exists(Crypto::KeyAgreementAlgorithmNode kaAlg |
    kaAlg = alg and
    isQuantumVulnerableKeyAgreementType(kaAlg.getKeyAgreementType()) and
    msg =
      "Quantum-vulnerable key agreement algorithm: " + kaAlg.getAlgorithmName() + "."
  )
select alg, msg
