import cpp
import experimental.quantum.Language

from Crypto::CipherOperationNode n
select n, n.getAnInputArtifact(), n.getAnOutputArtifact(), n.getAKey(), n.getANonce(),
  n.getAnAlgorithmOrGenericSource(), n.getKeyOperationSubtype()
