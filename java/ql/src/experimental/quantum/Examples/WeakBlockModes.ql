/**
 * @name Weak AES Block mode
 * @id java/quantum/examples/weak-block-modes
 * @description An AES cipher is in use with an insecure block mode
 * @kind problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

class WeakAESBlockModeAlgNode extends Crypto::KeyOperationAlgorithmNode {
  Crypto::ModeOfOperationAlgorithmNode mode;

  WeakAESBlockModeAlgNode() {
    this.getAlgorithmType() = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES()) and
    mode = super.getModeOfOperation() and
    (
      mode.getModeType() = Crypto::KeyOpAlg::ECB() or
      mode.getModeType() = Crypto::KeyOpAlg::CFB() or
      mode.getModeType() = Crypto::KeyOpAlg::OFB() or
      mode.getModeType() = Crypto::KeyOpAlg::CTR()
    )
  }

  Crypto::ModeOfOperationAlgorithmNode getMode() { result = mode }
}

from WeakAESBlockModeAlgNode alg
select alg, "Weak AES block mode instance $@.", alg.getMode(), alg.getMode().toString()
