/**
 * @name "PQC Test"
 */

import experimental.Quantum.Language

class AESGCMAlgorithmNode extends Crypto::KeyOperationAlgorithmNode {
  AESGCMAlgorithmNode() {
    this.getAlgorithmType() = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES()) and
    this.getModeOfOperation().getModeType() = Crypto::GCM()
  }
}

from Crypto::KeyOperationNode op, Crypto::NonceArtifactNode nonce
where op.getAKnownAlgorithm() instanceof AESGCMAlgorithmNode and nonce = op.getANonce()
select op, nonce.getSourceNode()
