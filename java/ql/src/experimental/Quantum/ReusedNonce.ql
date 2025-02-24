/**
 * @name Unsafe nonce source or reuse
 * @id java/unsafe-nonce-source-or-reuse
 */

import experimental.Quantum.Language
import semmle.code.java.dataflow.DataFlow

Element getNonceOrigin(Crypto::NonceArtifactInstance nonce) {
  // TODO: this check is currently ultra hacky just for demoing
  result = nonce.getInput().asExpr().(VarAccess).getVariable()
}

from
  Crypto::CipherOperationInstance op, Crypto::NonceArtifactInstance nonce1,
  Crypto::NonceArtifactInstance nonce2
where
  op.(Expr).getEnclosingCallable().getName() = "encrypt" and
  nonce1 = op.getNonce() and
  nonce2 = op.getNonce() and
  not nonce1 = nonce2 and
  getNonceOrigin(nonce1) = getNonceOrigin(nonce2)
select op, nonce1, nonce2
