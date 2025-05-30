import cpp
import experimental.quantum.Language

from Crypto::SignatureOperationNode op, Crypto::KeyArtifactNode key
where op.getAKey() = key
select op, key
// TODO: should key.getAKnownAlgorithm() return a value?
// TODO: add key.getSourceNode() when the test has any explicit key source (now we always generate new keys)
