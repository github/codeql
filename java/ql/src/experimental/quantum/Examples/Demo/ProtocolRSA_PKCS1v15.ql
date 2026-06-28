/**
 * @name RSA PKCS#1 v1.5 protocol detected
 * @description Detects RSA operations using PKCS#1 v1.5 padding, a quantum-vulnerable protocol composition.
 * @id java/quantum/examples/demo/protocol-rsa-pkcs1v15
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language
import Crypto::KeyOpAlg as KeyOpAlg

from Crypto::KeyOperationAlgorithmNode alg, string variant
where
  alg.getAlgorithmType() = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA()) and
  (
    // Explicit PKCS#1 v1.5 padding on a cipher operation
    alg.getPaddingAlgorithm().getPaddingType() = KeyOpAlg::PKCS1_V1_5() and
    variant = "explicit PKCS#1 v1.5 padding"
    or
    // RSA signature without PSS — implies PKCS#1 v1.5 (e.g., SHA256withRSA)
    exists(Crypto::SignatureOperationNode sigOp | alg = sigOp.getAKnownAlgorithm()) and
    not alg.getPaddingAlgorithm() instanceof Crypto::PssPaddingAlgorithmNode and
    variant = "implicit PKCS#1 v1.5 (RSA signature without PSS)"
  )
select alg, "RSA PKCS#1 v1.5 protocol detected: " + variant + "."
