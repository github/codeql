/**
 * @name Reuse of cryptographic nonce
 * @description Reuse of nonce in cryptographic operations can lead to vulnerabilities.
 * @id java/quantum/reused-nonce
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags quantum
 *       experimental
 */

import java
import ArtifactReuse

from Crypto::NonceArtifactNode nonce1, Crypto::NonceArtifactNode nonce2, Crypto::NodeBase sourceNode
where
  isArtifactReuse(nonce1, nonce2) and
  // NOTE: in general we may not know a source, but see possible reuse,
  // we are not detecting these cases here (only where the source is the same).
  sourceNode = nonce1.getSourceNode() and
  sourceNode = nonce2.getSourceNode() and
  // Null literals are typically used for initialization, and if two 'nulls'
  // are reused, it is likely an uninitialization path that would result in a NullPointerException.
  not sourceNode.asElement() instanceof NullLiteral and
  // if the nonce is used in an encryption and decryption, ignore that reuse
  not exists(Crypto::CipherOperationNode op1, Crypto::CipherOperationNode op2 |
    op1 != op2 and
    op1.getANonce() = nonce1 and
    op2.getANonce() = nonce2 and
    (
      (
        op1.getKeyOperationSubtype() instanceof Crypto::TEncryptMode or
        op1.getKeyOperationSubtype() instanceof Crypto::TWrapMode
      ) and
      (
        op2.getKeyOperationSubtype() instanceof Crypto::TDecryptMode or
        op2.getKeyOperationSubtype() instanceof Crypto::TUnwrapMode
      )
      or
      (
        op2.getKeyOperationSubtype() instanceof Crypto::TEncryptMode or
        op2.getKeyOperationSubtype() instanceof Crypto::TWrapMode
      ) and
      (
        op1.getKeyOperationSubtype() instanceof Crypto::TDecryptMode or
        op1.getKeyOperationSubtype() instanceof Crypto::TUnwrapMode
      )
    )
  )
select sourceNode, "Nonce source is reused, see $@ and $@", nonce1, nonce1.toString(), nonce2,
  nonce2.toString()
