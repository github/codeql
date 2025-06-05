import cpp
import experimental.quantum.Language

from Crypto::SignatureOperationNode n, Crypto::MessageArtifactNode m
where n.getAnInputArtifact() = m
select n, m, m.getSourceNode()
