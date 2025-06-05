import cpp
import experimental.quantum.Language
import experimental.quantum.OpenSSL.Operations.EVPKeyGenOperation

from Crypto::KeyGenerationOperationInstance n //KeyGenerationOperationNode n
select n, n.getOutputKeyArtifact(), n.getKeyArtifactOutputInstance() // , n.getAnAlgorithmOrGenericSource()
