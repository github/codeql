/**
 * @name Secure and quantum-proof symmetric cipher
 * @description Detects use of symmetric cipher algorithms considered secure and quantum-proof.
 * @id java/quantum/examples/demo/secure-cipher
 * @kind problem
 * @problem.severity recommendation
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::KeyOperationAlgorithmNode alg, KeyOpAlg::TSymmetricCipherType cipherType, string detail
where
  alg.getAlgorithmType() = KeyOpAlg::TSymmetricCipher(cipherType) and
  isSecureCipherType(cipherType) and
  (
    if exists(alg.getKeySizeFixed())
    then
      detail =
        "Secure symmetric cipher: " + alg.getAlgorithmType().toString() + " (" +
          alg.getKeySizeFixed().toString() + "-bit key)."
    else detail = "Secure symmetric cipher: " + alg.getAlgorithmType().toString() + "."
  )
select alg, detail
