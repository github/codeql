import cpp
import experimental.quantum.Language

from Crypto::CipherOperationNode op, Crypto::KeyArtifactNode k
where op.getAKey() = k
select op, k, k.getSourceNode()
