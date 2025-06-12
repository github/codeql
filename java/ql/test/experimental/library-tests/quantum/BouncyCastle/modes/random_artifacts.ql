import java
import experimental.quantum.Language

from Crypto::ArtifactNode n
where any(SecureRandomnessInstance rng).flowsTo(n.asElement())
select n
