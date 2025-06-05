/**
 * @name Reuse of cryptographic nonce
 * @description Reuse of nonce in cryptographic operations can lead to vulnerabilities.
 * @id java/quantum/reused-nonce
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @tags quantum
 *       experimental
 */

import java
import ArtifactReuse

from Crypto::NonceArtifactNode nonce1, Crypto::NonceArtifactNode nonce2
where isArtifactReuse(nonce1, nonce2)
select nonce1, "Reuse with nonce $@", nonce2, nonce2.toString()
