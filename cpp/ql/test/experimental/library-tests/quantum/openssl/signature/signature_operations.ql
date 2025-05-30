import cpp
import experimental.quantum.Language
import experimental.quantum.OpenSSL.AlgorithmValueConsumers.PKeyAlgorithmValueConsumer
import experimental.quantum.OpenSSL.CtxFlow
import experimental.quantum.OpenSSL.Operations.EVPSignatureOperation
import experimental.quantum.OpenSSL.Operations.OpenSSLOperationBase

from Crypto::SignatureOperationNode n
select n, n.getAnInputArtifact(), n.getAnOutputArtifact(), n.getAKey(),
  n.getAnAlgorithmOrGenericSource(), n.getKeyOperationSubtype()
  // , n.getASignatureArtifact()
  
