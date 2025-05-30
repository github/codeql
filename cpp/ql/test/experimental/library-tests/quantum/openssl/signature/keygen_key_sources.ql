import cpp
import experimental.quantum.Language
import experimental.quantum.OpenSSL.Operations.EVPKeyGenOperation

from EVPKeyGenOperation keyGen, Crypto::KeyArtifactNode key
where keyGen = key.asElement().(Crypto::KeyArtifactOutputInstance).getCreator()
select keyGen, key, key.getAKnownAlgorithm()
// TODO: add key.getSourceNode() when the test has any explicit key source (now we always generate new keys)
