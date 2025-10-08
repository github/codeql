/**
 * @name Unknown nonce/iv initialization
 * @id java/quantum/unknown-iv-or-nonce-initialization
 * @description A nonce/iv is generated from a source that is not secure. Failure to initialize
 *              an IV or nonce properly can lead to vulnerabilities such as replay attacks or key recovery.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

from Crypto::NonceArtifactNode nonce
where exists(nonce.getSourceNode())
select nonce, "Unknown (unobserved) IV/Nonce initialization."
