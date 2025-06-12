import java
import experimental.quantum.Language

string getASignatureInput(Crypto::SignatureOperationNode n) {
  exists(Crypto::SignatureArtifactNode input |
    input = n.getASignatureArtifact() and result = input.toString()
  )
  or
  not exists(n.getASignatureArtifact()) and result = ""
}

string getASignatureOutput(Crypto::SignatureOperationNode n) {
  exists(Crypto::KeyOperationOutputNode output |
    output = n.getAnOutputArtifact() and result = output.toString()
  )
  or
  not exists(n.getAnOutputArtifact()) and result = ""
}

from Crypto::SignatureOperationNode n
select n, n.getAKnownAlgorithm(), n.getAKey(), n.getAnInputArtifact(), getASignatureInput(n),
  getASignatureOutput(n)
