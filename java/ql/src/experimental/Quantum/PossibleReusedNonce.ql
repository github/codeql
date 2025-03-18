/**
 * @name Possible Nonce Reuse: Produces false positives if reuse occurs in a source that is a re-entry point.
 * @id java/possible-nonce-reuse
 * @kind problem
 */

import experimental.Quantum.Language
import semmle.code.java.dataflow.DataFlow

from
  Crypto::CipherOperationNode op1, Crypto::CipherOperationNode op2,
  Crypto::NonceArtifactNode nonce1, Crypto::NonceArtifactNode nonce2, Crypto::FlowAwareElement src1,
  Crypto::FlowAwareElement src2
where
  // NOTE: not looking at value of the nonce, if we knew value, it would be insecure (hard coded)
  // Instead trying to find nonce sources that trace to multiple operations.
  // Only looking for encryption operations, presumably if reuse for decryption either wouldn't be observable
  // (the encryption happened else where) or we are able to see the encryption and decryption operation and
  // reuse for encryption is the concern)
  (
    op1.getCipherOperationSubtype() instanceof Crypto::EncryptionSubtype or
    op1.getCipherOperationSubtype() instanceof Crypto::WrapSubtype or
    op1.getCipherOperationSubtype() instanceof Crypto::UnknownCipherOperationSubtype
  ) and
  (
    op2.getCipherOperationSubtype() instanceof Crypto::EncryptionSubtype or
    op2.getCipherOperationSubtype() instanceof Crypto::WrapSubtype or
    op2.getCipherOperationSubtype() instanceof Crypto::UnknownCipherOperationSubtype
  ) and
  nonce1 = op1.getANonce() and
  nonce2 = op2.getANonce() and
  op1 != op2 and
  nonce1.getSourceElement() = src1 and
  nonce2.getSourceElement() = src2 and
  src1 = src2
// TODO: need to clarify that a reuse in a non-finalize is ok, need to check if 'finalize' through a modeled predicate
select op1, "Operation has a possible reused nonce with source $@", src1, src1.toString()
