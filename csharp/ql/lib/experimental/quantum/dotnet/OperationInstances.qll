private import csharp
private import experimental.quantum.Language
private import DataFlow
private import FlowAnalysis
private import Cryptography

class ECDsaORRSASigningOperationInstance extends Crypto::SignatureOperationInstance instanceof SignerUse
{
  SigningCreateCall creator;

  ECDsaORRSASigningOperationInstance() {
    creator = SigningCreateToUseFlow::getCreationFromUse(this, _, _)
  }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    result = creator.getAlgorithmArg()
  }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if super.isSigner()
    then result = Crypto::TSignMode()
    else
      if super.isVerifier()
      then result = Crypto::TVerifyMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    result.asExpr() = creator.getKeyConsumer()
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() { none() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result.asExpr() = super.getMessageArg()
  }

  override Crypto::ConsumerInputDataFlowNode getSignatureConsumer() {
    result.asExpr() = super.getSignatureArg()
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result.asExpr() = super.getSignatureOutput()
  }
}

class HashOperationInstance extends Crypto::HashOperationInstance instanceof HashUse {
  HashAlgorithmCreateCall creator;

  HashOperationInstance() { creator = HashCreateToUseFlow::getCreationFromUse(this, _, _) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { none() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { none() }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() { none() }
}
