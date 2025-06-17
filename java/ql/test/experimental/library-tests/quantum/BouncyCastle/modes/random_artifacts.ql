import java
import experimental.quantum.Language

from Crypto::ArtifactNode n
where n.getSourceNode() instanceof Crypto::RandomNumberGenerationNode
select n, n.getSourceNode()
