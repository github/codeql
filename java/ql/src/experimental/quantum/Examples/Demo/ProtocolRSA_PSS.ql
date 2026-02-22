/**
 * @name RSA-PSS protocol detected
 * @description Detects RSA signature with PSS padding, a quantum-vulnerable protocol composition.
 * @id java/quantum/examples/demo/protocol-rsa-pss
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language
import Crypto::KeyOpAlg as KeyOpAlg

from
  Crypto::KeyOperationAlgorithmNode alg, Crypto::PSSPaddingAlgorithmNode pss
where
  alg.getAlgorithmType() = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA()) and
  pss = alg.getPaddingAlgorithm()
select alg, "RSA-PSS (RSASSA-PSS) protocol detected with PSS padding $@.", pss, pss.toString()
