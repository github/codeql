import cpp
import experimental.quantum.Language
import experimental.quantum.OpenSSL.Operations.EVPKeyGenOperation

from EVPKeyGenOperation keyGen, Crypto::KeyArtifactNode key
where keyGen = key.asElement().(Crypto::KeyArtifactOutputInstance).getCreator()
select keyGen, key, key.getAKnownAlgorithm()
