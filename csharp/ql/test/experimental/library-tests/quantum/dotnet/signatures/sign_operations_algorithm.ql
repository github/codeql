import csharp
import experimental.quantum.Language

from Crypto::SignatureOperationNode signature, Crypto::AlgorithmNode algorithm
where algorithm = signature.getAKnownAlgorithm()
select signature, algorithm.getAlgorithmName(), algorithm.getRawAlgorithmName()
