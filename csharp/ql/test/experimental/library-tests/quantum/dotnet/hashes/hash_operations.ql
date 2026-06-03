import csharp
import experimental.quantum.Language

from Crypto::HashOperationNode n, Crypto::AlgorithmNode algo
where algo = n.getAKnownAlgorithm()
select n, n.getDigest(), n.getInputArtifact(), algo.getAlgorithmName(), algo.getRawAlgorithmName()
