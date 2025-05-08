/**
 * @name Detects reuse of the same nonce in multiple operations
 * @id java/crypto_inventory_filter/nonce_reuse
 * @kind problem
 */

import java
import ArtifactReuse

from Crypto::NonceArtifactNode nonce1, Crypto::NonceArtifactNode nonce2
where isArtifactReuse(nonce1, nonce2)
select nonce1, "Reuse with nonce $@", nonce2, nonce2.toString()
