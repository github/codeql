private import csharp
private import experimental.quantum.Language
private import DataFlow
private import FlowAnalysis
private import Cryptography

class ECDsaORRSASigningOperationInstance extends Crypto::SignatureOperationInstance instanceof DotNetSigner
{
  CryptographyCreateCall creator;

  ECDsaORRSASigningOperationInstance() {
    CryptographyCreateToUseFlow::flow(DataFlow::exprNode(creator), DataFlow::exprNode(this))
  }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    result = creator.getAlgorithmArg()
    or
    // FIXME: currently not working
    result = super.getHashAlgorithmArg()
  }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if super.isSigner()
    then result = Crypto::TSignMode()
    else
      if super.isVerifier()
      then result = Crypto::TVerifyMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }

  // TODO FIXME
  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    result.asExpr() = creator.getAlgorithmArg()
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
