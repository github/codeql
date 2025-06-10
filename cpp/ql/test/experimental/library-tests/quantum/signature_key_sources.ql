import cpp
import experimental.quantum.Language

from Crypto::SignatureOperationNode op, Crypto::KeyArtifactNode key
where op.getAKey() = key
select op, key
