import cpp
import experimental.quantum.Language

from Crypto::CipherOperationNode op, Crypto::NonceArtifactNode n
where op.getANonce() = n
select op, n, n.getSourceNode()
