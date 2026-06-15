/**
 * @name Cipher not AES-GCM mode
 * @id java/quantum/examples/non-aes-gcm
 * @description An AES cipher is in use without GCM
 * @kind problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

class NonAESGCMAlgorithmNode extends Crypto::KeyOperationAlgorithmNode {
  NonAESGCMAlgorithmNode() {
    this.getAlgorithmType() = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES()) and
    this.getModeOfOperation().getModeType() != Crypto::KeyOpAlg::GCM()
  }
}

from Crypto::KeyOperationNode op, Crypto::KeyOperationOutputNode codeNode
where
  op.getAKnownAlgorithm() instanceof NonAESGCMAlgorithmNode and
  codeNode = op.getAnOutputArtifact()
select op, "Non-AES-GCM instance."
