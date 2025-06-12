import java
import experimental.quantum.Language

from Crypto::CipherOperationNode n
select n, n.getAKnownAlgorithm(), n.getAKey(), n.getANonce(), n.getAnInputArtifact(),
  n.getAnOutputArtifact()
