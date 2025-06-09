import cpp
import experimental.quantum.Language
import experimental.quantum.OpenSSL.OpenSSL

from Crypto::KeyGenerationOperationNode n
select n, n.getOutputKeyArtifact(), n.getAnAlgorithmOrGenericSource()
