/**
 * @name Weak AES Block mode
 * @id java/quantum/weak-block-modes
 * @description An AES cipher is in use with an insecure block mode
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

class WeakAESBlockModeAlgNode extends Crypto::KeyOperationAlgorithmNode {
  WeakAESBlockModeAlgNode() {
    this.getAlgorithmType() = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES()) and
    (this.getModeOfOperation().getModeType() = Crypto::KeyOpAlg::ECB() or
     this.getModeOfOperation().getModeType() = Crypto::KeyOpAlg::CFB() or
     this.getModeOfOperation().getModeType() = Crypto::KeyOpAlg::OFB() or
     this.getModeOfOperation().getModeType() = Crypto::KeyOpAlg::CTR()
    )
  }
}

from Crypto::KeyOperationNode op, Crypto::KeyOperationOutputNode codeNode
where op.getAKnownAlgorithm() instanceof WeakAESBlockModeAlgNode and
    codeNode = op.getAnOutputArtifact()
select op, "Weak AES block mode instance."
