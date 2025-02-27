/**
 * @name Unsafe nonce source or reuse
 * @id java/unsafe-nonce-source-or-reuse
 */

import experimental.Quantum.Language
import semmle.code.java.dataflow.DataFlow

Crypto::NodeBase getNonceOrigin(Crypto::NonceNode nonce) {
  // TODO: this check is currently ultra hacky just for demoing
  result = nonce.getSourceNode()
}

from Crypto::CipherOperationNode op, Crypto::NonceNode nonce1, Crypto::NonceNode nonce2
where
  op.asElement().(Expr).getEnclosingCallable().getName() = "encrypt" and
  nonce1 = op.getANonce() and
  nonce2 = op.getANonce() and
  not nonce1 = nonce2 and
  getNonceOrigin(nonce1) = getNonceOrigin(nonce2)
select op, nonce1, nonce2
