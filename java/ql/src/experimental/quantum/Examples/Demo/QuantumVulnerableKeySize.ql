/**
 * @name Quantum-vulnerable key size
 * @description Detects key sizes used with quantum-vulnerable algorithms, reporting the specific size in use.
 * @id java/quantum/examples/demo/quantum-vulnerable-key-size
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::KeyCreationOperationNode keygen, Crypto::AlgorithmNode alg, int keySize
where
  alg = keygen.getAKnownAlgorithm() and
  keygen.getAKeySizeSource().asElement().(Literal).getValue().toInt() = keySize and
  (
    exists(Crypto::KeyOperationAlgorithmNode keyAlg |
      keyAlg = alg and isQuantumVulnerableAlgorithmType(keyAlg.getAlgorithmType())
    )
    or
    exists(Crypto::KeyAgreementAlgorithmNode kaAlg |
      kaAlg = alg and isQuantumVulnerableKeyAgreementType(kaAlg.getKeyAgreementType())
    )
  )
select keygen,
  "Quantum-vulnerable key size (" + keySize.toString() + " bits) for algorithm $@.", alg,
  alg.getAlgorithmName()
