/**
 * @name Insecure symmetric cipher
 * @description Detects use of classically insecure symmetric cipher algorithms.
 * @id java/quantum/examples/demo/insecure-cipher
 * @kind problem
 * @problem.severity error
 * @tags external/cwe/cwe-327
 *       quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::KeyOperationAlgorithmNode alg, KeyOpAlg::TSymmetricCipherType cipherType
where
  alg.getAlgorithmType() = KeyOpAlg::TSymmetricCipher(cipherType) and
  isInsecureCipherType(cipherType)
select alg, "Insecure symmetric cipher: " + alg.getAlgorithmName() + "."
