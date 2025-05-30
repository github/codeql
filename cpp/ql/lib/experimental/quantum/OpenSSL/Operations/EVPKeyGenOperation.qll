private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import semmle.code.cpp.dataflow.new.DataFlow

class EVPKeyGenInitialize extends EVPInitialize {
  EVPKeyGenInitialize() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_keygen_init",
        "EVP_PKEY_paramgen_init"
      ]
  }

  override Expr getAlgorithmArg() { result = getAlgorithmFromCtx(this.getContextArg()) }
}

class EVPKeyGenOperation extends EVPOperation, Crypto::KeyGenerationOperationInstance {
  EVPKeyGenOperation() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_generate", "EVP_PKEY_keygen", "EVP_PKEY_Q_keygen", "EVP_PKEY_paramgen"
        // TODO: "EVP_PKEY_paramgen"
      ]
  }

  override Expr getAlgorithmArg() {
    if this.(Call).getTarget().getName() = "EVP_PKEY_Q_keygen"
    then result = this.(Call).getArgument(0)
    else result = EVPOperation.super.getAlgorithmArg()
  }

  override Crypto::KeyArtifactType getOutputKeyType() { result = Crypto::TAsymmetricKeyType() }

  override Expr getInputArg() { none() }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() {
    result = EVPOperation.super.getOutputKeyArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    none() // TODO
  }

  override int getKeySizeFixed() {
    none() // TODO
  }
}
