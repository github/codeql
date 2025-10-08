/**
 * @name Insecure nonce/iv (static value or weak random source)
 * @id java/quantum/insecure-iv-or-nonce
 * @description A nonce/iv is generated from a source that is not secure. This can lead to
 *              vulnerabilities such as replay attacks or key recovery.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

from Crypto::NonceArtifactNode nonce, Crypto::NodeBase src
where
  nonce.getSourceNode() = src and
  not src.asElement() instanceof SecureRandomnessInstance
select nonce, "Nonce or IV uses insecure or constant source $@", src, src.toString()
