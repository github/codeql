import cpp
import experimental.quantum.Language

from Crypto::SignatureOperationNode n
select n, n.getAnInputArtifact(), n.getAnOutputArtifact(), n.getAKey(),
  n.getAnAlgorithmOrGenericSource(), n.getKeyOperationSubtype()
