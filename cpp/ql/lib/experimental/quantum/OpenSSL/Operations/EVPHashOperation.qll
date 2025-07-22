/**
 * https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
 */

private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

class Evp_DigestInit_Variant_Calls extends EvpPrimaryAlgorithmInitializer {
  Evp_DigestInit_Variant_Calls() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestInit", "EVP_DigestInit_ex", "EVP_DigestInit_ex2"
      ]
  }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class Evp_Digest_Update_Call extends EvpUpdate {
  Evp_Digest_Update_Call() { this.(Call).getTarget().getName() = "EVP_DigestUpdate" }

  override Expr getInputArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

//https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
class Evp_Q_Digest_Operation extends EvpOperation, Crypto::HashOperationInstance {
  Evp_Q_Digest_Operation() { this.(Call).getTarget().getName() = "EVP_Q_digest" }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }

  override EvpInitializer getInitCall() {
    // This variant of digest does not use an init
    // and even if it were used, the init would be ignored/undefined
    none()
  }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }

  override Expr getOutputArg() { result = this.(Call).getArgument(5) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = EvpOperation.super.getOutputArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = EvpOperation.super.getInputConsumer()
  }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class Evp_Digest_Operation extends EvpOperation, Crypto::HashOperationInstance {
  Evp_Digest_Operation() { this.(Call).getTarget().getName() = "EVP_Digest" }

  // There is no context argument for this function
  override CtxPointerSource getContext() { none() }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(4) }

  override EvpPrimaryAlgorithmInitializer getInitCall() {
    // This variant of digest does not use an init
    // and even if it were used, the init would be ignored/undefined
    none()
  }

  override Expr getInputArg() { result = this.(Call).getArgument(0) }

  override Expr getOutputArg() { result = this.(Call).getArgument(2) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = EvpOperation.super.getOutputArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = EvpOperation.super.getInputConsumer()
  }
}

class Evp_Digest_Final_Call extends EvpFinal, Crypto::HashOperationInstance {
  Evp_Digest_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestFinal", "EVP_DigestFinal_ex", "EVP_DigestFinalXOF"
      ]
  }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = EvpFinal.super.getOutputArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = EvpFinal.super.getInputConsumer()
  }

  override Expr getAlgorithmArg() {
    result = this.getInitCall().(EvpPrimaryAlgorithmInitializer).getAlgorithmArg()
  }
}
