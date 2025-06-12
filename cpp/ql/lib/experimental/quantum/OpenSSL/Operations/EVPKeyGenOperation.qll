private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import semmle.code.cpp.dataflow.new.DataFlow

class EVPKeyGenInitialize extends EvpPrimaryAlgorithmInitializer {
  EVPKeyGenInitialize() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_keygen_init",
        "EVP_PKEY_paramgen_init"
      ]
  }

  /**
   * The algorithm is encoded through the context argument.
   * The context may be directly created from an algorithm consumer,
   * or from a new operation off of a prior key. Either way,
   * we will treat this argument as the algorithm argument.
   */
  override Expr getAlgorithmArg() { result = this.getContext() }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EVPKeyGenOperation extends EVPFinal, Crypto::KeyGenerationOperationInstance {
  DataFlow::Node keyResultNode;

  EVPKeyGenOperation() {
    this.(Call).getTarget().getName() in ["EVP_RSA_gen", "EVP_PKEY_Q_keygen"] and
    keyResultNode.asExpr() = this
    or
    this.(Call).getTarget().getName() in ["EVP_PKEY_generate", "EVP_PKEY_keygen"] and
    keyResultNode.asDefiningArgument() = this.(Call).getArgument(1)
  }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }

  override Expr getAlgorithmArg() {
    this.(Call).getTarget().getName() = "EVP_PKEY_Q_keygen" and
    result = this.(Call).getArgument(0)
    or
    result = this.getInitCall().(EvpPrimaryAlgorithmInitializer).getAlgorithmArg()
  }

  override Crypto::KeyArtifactType getOutputKeyType() { result = Crypto::TAsymmetricKeyType() }

  override Expr getInputArg() { none() }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() { result = keyResultNode }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    this.(Call).getTarget().getName() = "EVP_PKEY_Q_keygen" and
    result = DataFlow::exprNode(this.(Call).getArgument(3)) and
    // Arg 3 (0 based) is only a key size if the 'type' parameter is RSA, however,
    // as a crude approximation, assume that if the type of the argument is not a derived type
    // the argument must specify a key size (this is to avoid tracing if "rsa" is in the type parameter)
    not this.(Call).getArgument(3).getType().getUnderlyingType() instanceof DerivedType
    or
    this.(Call).getTarget().getName() = "EVP_RSA_gen" and
    result = DataFlow::exprNode(this.(Call).getArgument(0))
    or
    result = DataFlow::exprNode(this.getInitCall().(EvpKeySizeInitializer).getKeySizeArg())
  }
}
