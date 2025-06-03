import cpp
import experimental.quantum.Language

from Crypto::HashOperationNode n, Crypto::MessageArtifactNode m
where n.getInputArtifact() = m
select n, m, m.getSourceNode()
