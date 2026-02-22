/**
 * @name RSA-OAEP protocol detected
 * @description Detects RSA encryption with OAEP padding, a quantum-vulnerable protocol composition.
 * @id java/quantum/examples/demo/protocol-rsa-oaep
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language
import Crypto::KeyOpAlg as KeyOpAlg

from Crypto::KeyOperationAlgorithmNode alg, Crypto::OAEPPaddingAlgorithmNode pad
where
  alg.getAlgorithmType() = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA()) and
  pad = alg.getPaddingAlgorithm()
select alg, "RSA-OAEP protocol detected with OAEP padding $@.", pad, pad.toString()
