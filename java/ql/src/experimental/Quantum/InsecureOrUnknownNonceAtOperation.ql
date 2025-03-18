/**
 * @name Insecure or unknown nonce source at a cipher operation
 * @id java/insecure-or-unknown-nonce-at-operation
 * @kind problem
 */

import experimental.Quantum.Language

from
  Crypto::NonceArtifactNode n, Crypto::CipherOperationNode op, Crypto::FlowAwareElement src,
  string msg
where
  op.getANonce() = n and
  // Only encryption mode is relevant for insecure nonces, consder any 'unknown' subtype
  // as possibly encryption.
  (
    op.getCipherOperationSubtype() instanceof Crypto::EncryptionSubtype
    or
    op.getCipherOperationSubtype() instanceof Crypto::WrapSubtype
    or
    op.getCipherOperationSubtype() instanceof Crypto::UnwrapSubtype
  ) and
  (
    // Known sources cases that are not secure
    src = n.getSourceElement() and
    not src instanceof SecureRandomnessInstance and
    msg = "Operation uses insecure nonce source $@"
    or
    // Totally unknown sources (unmodeled input sources)
    not exists(n.getSourceElement()) and
    msg = "Operation uses unknown nonce source" and
    src = n.asElement()
  )
select n, msg, src, src.toString()
// variant using instances, does not yield the same results
// from Crypto::NonceArtifactConsumer n, Crypto::CipherOperationInstance op, Crypto::FlowAwareElement src, string msg
// where
//   op.getNonceConsumer() = n and
// TODO: only perform the query on encryption
//   (
//     // Known sources cases that are not secure
//     src = n.getAKnownArtifactSource()and
//       not src instanceof SecureRandomnessInstance and
//       msg = "Operation uses insecure nonce source $@"
//     or
//     // Totally unknown sources (unmodeled input sources)
//     // When this occurs set src to n, just to bind it, but the output message will not report any source
//     not exists(n.getAKnownArtifactSource()) and msg = "Operation uses unknown nonce source" and src = n
//   )
// select n, msg, src, src.toString()
// NOTE: this will find all unknowns too, constants, and allocations, without needing to model them
// which is kinda nice, but accidental, since getSourceElement is not modeled for everything
// If users want to find constants or unallocated, they need to model those sources, and output the
// getSourceElement
// QUESTION: why isn't the source element a node?
// NOTE: when not all sources are modeled, if one source is secure, even if others do exist, you
// will see the nonce and operation are secure, regardless of potentially insecure IV sources
// resulting in False Negatives
// NOTE: need to have a query where the op has no Nonce
// // Ideal query
// from Crypto::NonceNode n, Crypto::CipherOperationNode op
// where
// n = op.getANonce() and
// // n = op.getAnUnknownNonce()
// not n.asElement() instanceof SecureRandomSource
// select op, "Operation uses insecure nonce source @", n, n.toString()
//  from Crypto::Nonce n, Crypto::ArtifactLocatableElement nonceSrc
//  where
//    n.() = nonceSrc and
//    not nonceSrc instanceof SecureRandomnessInstance
// select n, nonceSrc
