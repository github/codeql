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

/**
 * All calls that can be tracked via ctx.
 * For example calls used to set parameters like a key size.
 */
class EVPKeyGenUpdate extends EVPUpdate {
  EVPKeyGenUpdate() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_CTX_set_rsa_keygen_bits",
        // TODO: "EVP_PKEY_CTX_set_params"
      ]
  }

  /**
   * No input in our meaning.
   */
  override Expr getInputArg() { none() }

  /**
   * No output in our meaning.
   */
  override Expr getOutputArg() { none() }

  Expr getKeySizeArg() {
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_rsa_keygen_bits" and
    result = this.(Call).getArgument(1)
  }
}

class EVPKeyGenOperation extends EVPFinal, Crypto::KeyGenerationOperationInstance {
  EVPKeyGenOperation() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_generate", "EVP_PKEY_keygen", "EVP_PKEY_Q_keygen", "EVP_PKEY_paramgen",
        "EVP_RSA_gen"
        // TODO: "EVP_PKEY_paramgen" may need special handling
        // TODO: RSA_generate_key, RSA_generate_key_ex, etc
      ]
  }

  override Expr getAlgorithmArg() {
    if this.(Call).getTarget().getName() = "EVP_PKEY_Q_keygen"
    then result = this.(Call).getArgument(0)
    else
      if this.(Call).getTarget().getName() = "EVP_RSA_gen"
      then result = this
      else result = EVPFinal.super.getAlgorithmArg()
  }

  override Crypto::KeyArtifactType getOutputKeyType() { result = Crypto::TAsymmetricKeyType() }

  override Expr getInputArg() { none() }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() {
    result = EVPFinal.super.getOutputKeyArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    if this.(Call).getTarget().getName() = "EVP_PKEY_Q_keygen"
    then result = DataFlow::exprNode(this.(Call).getArgument(3)) // TODO: may be wrong for EC keys
    else
      if this.(Call).getTarget().getName() = "EVP_RSA_gen"
      then result = DataFlow::exprNode(this.(Call).getArgument(0))
      else result = DataFlow::exprNode(this.getUpdateCalls().(EVPKeyGenUpdate).getKeySizeArg())
  }

  override int getKeySizeFixed() {
    none() // TODO
  }
}
