import java
import experimental.quantum.Language

string getAnOutputArtifact(Crypto::KeyOperationNode n) {
  exists(Crypto::KeyOperationOutputNode output |
    output = n.getAnOutputArtifact() and result = output.toString()
  )
  or
  not exists(n.getAnOutputArtifact()) and result = ""
}

from Crypto::SignatureOperationNode n
select n, n.getAKey(), n.getAnInputArtifact(), getAnOutputArtifact(n)
