import csharp
import experimental.quantum.Language

from Crypto::CipherOperationNode n, Crypto::MessageArtifactNode m
where n.getAnInputArtifact() = m
select n, m, m.getSourceNode()
