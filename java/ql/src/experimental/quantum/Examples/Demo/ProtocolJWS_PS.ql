/**
 * @name JWS PS protocol detected (PS256/PS384/PS512)
 * @description Detects RSA-PSS signature with SHA-2 hash, corresponding to JWS PS256/PS384/PS512.
 * @id java/quantum/examples/demo/protocol-jws-ps
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language
import Crypto::KeyOpAlg as KeyOpAlg

from
  Crypto::SignatureOperationNode sigOp, Crypto::KeyOperationAlgorithmNode alg,
  Crypto::PSSPaddingAlgorithmNode pss, Crypto::HashAlgorithmNode hash, int digestLen
where
  alg = sigOp.getAKnownAlgorithm() and
  alg.getAlgorithmType() = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA()) and
  pss = alg.getPaddingAlgorithm() and
  // Get hash from the PSS padding or from the signature operation
  (
    hash = pss.getPSSHashAlgorithm()
    or
    hash = sigOp.getHashAlgorithm() and not exists(pss.getPSSHashAlgorithm())
  ) and
  hash.getHashType() = Crypto::SHA2() and
  digestLen = hash.getDigestLength() and
  digestLen in [256, 384, 512]
select alg,
  "JWS PS" + digestLen.toString() + " protocol detected (RSA-PSS + SHA-" + digestLen.toString() +
    ")."
