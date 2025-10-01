/**
 * @name Cipher is Weak RSA Implementation
 * @id java/quantum/weak-rsa
 * @description RSA with a key length <2048 found
 * @kind problem
 * @problem.severity error
 * @security.severity low
 * @precision high
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

class WeakRSAAlgorithmNode extends Crypto::KeyOperationAlgorithmNode {
  WeakRSAAlgorithmNode() {
    this.getAlgorithmType() = Crypto::KeyOpAlg::TAsymmetricCipher(Crypto::KeyOpAlg::RSA()) and
    this.getKeySizeFixed() < 2048
  }
}

from Crypto::KeyOperationNode op, string message
where op.getAKnownAlgorithm() instanceof WeakRSAAlgorithmNode and
     message = "Weak RSA instance found with key length <2048"
select op, message
