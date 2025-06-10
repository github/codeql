import cpp
import experimental.quantum.Language

from Crypto::KeyOperationNode op, Crypto::NonceArtifactNode n
where op.getANonce() = n
select op, n
