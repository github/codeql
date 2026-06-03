import csharp
import experimental.quantum.Language

from Crypto::MACOperationNode n, Crypto::AlgorithmNode algo
where n.getAKnownAlgorithm() = algo
select n, algo.getRawAlgorithmName(), algo.getAlgorithmName()
