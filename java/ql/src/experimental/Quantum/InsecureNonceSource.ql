/**
 * @name Insecure nonce at a cipher operation
 * @id java/insecure-nonce
 * @kind problem
 * @problem.severity error
 * @precision high
 * @description A nonce is generated from a source that is not secure. This can lead to
 *              vulnerabilities such as replay attacks or key recovery.
 */

import experimental.Quantum.Language

predicate isInsecureNonceSource(Crypto::NonceArtifactNode n, Crypto::NodeBase src) {
  src = n.getSourceNode() and
  not src.asElement() instanceof SecureRandomnessInstance
}

from Crypto::KeyOperationNode op, Crypto::NodeBase src
where isInsecureNonceSource(op.getANonce(), src)
select op, "Operation uses insecure nonce source $@", src, src.toString()
