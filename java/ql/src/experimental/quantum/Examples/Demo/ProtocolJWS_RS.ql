/**
 * @name JWS RS protocol detected (RS256/RS384/RS512)
 * @description Detects RSA PKCS#1 v1.5 signature with SHA-2 hash, corresponding to JWS RS256/RS384/RS512.
 * @id java/quantum/examples/demo/protocol-jws-rs
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language
import Crypto::KeyOpAlg as KeyOpAlg

from
  Crypto::SignatureOperationNode sigOp, Crypto::KeyOperationAlgorithmNode alg,
  Crypto::HashAlgorithmNode hash, int digestLen
where
  alg = sigOp.getAKnownAlgorithm() and
  alg.getAlgorithmType() = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA()) and
  // No PSS padding — implies PKCS#1 v1.5
  not alg.getPaddingAlgorithm() instanceof Crypto::PSSPaddingAlgorithmNode and
  // Hash is SHA-2 with standard JWS digest lengths
  hash = sigOp.getHashAlgorithm() and
  hash.getHashType() = Crypto::SHA2() and
  digestLen = hash.getDigestLength() and
  digestLen in [256, 384, 512]
select alg,
  "JWS RS" + digestLen.toString() + " protocol detected (RSA PKCS#1 v1.5 + SHA-" +
    digestLen.toString() + ")."
