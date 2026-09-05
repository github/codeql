/**
 * @name Secure and quantum-proof hash algorithm
 * @description Detects use of hash algorithms considered secure and quantum-proof.
 * @id java/quantum/examples/demo/secure-hash
 * @kind problem
 * @problem.severity recommendation
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::HashAlgorithmNode alg, string detail
where
  isSecureHashType(alg.getHashType()) and
  (
    if exists(alg.getDigestLength())
    then
      detail =
        "Secure hash algorithm: " + alg.getHashType().toString() + " (" +
          alg.getDigestLength().toString() + "-bit digest)."
    else detail = "Secure hash algorithm: " + alg.getHashType().toString() + "."
  )
select alg, detail
