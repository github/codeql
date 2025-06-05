private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

module EncValToInitEncArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getValue().toInt() in [0, 1] }

  predicate isSink(DataFlow::Node sink) {
    exists(EVP_Cipher_Initializer initCall | sink.asExpr() = initCall.getOperationSubtypeArg())
  }
}

module EncValToInitEncArgFlow = DataFlow::Global<EncValToInitEncArgConfig>;

int getEncConfigValue(Expr e) {
  exists(EVP_Cipher_Initializer initCall | e = initCall.getOperationSubtypeArg()) and
  exists(DataFlow::Node a, DataFlow::Node b |
    EncValToInitEncArgFlow::flow(a, b) and b.asExpr() = e and result = a.asExpr().getValue().toInt()
  )
}

bindingset[i]
Crypto::KeyOperationSubtype intToCipherOperationSubtype(int i) {
  if i = 0
  then result instanceof Crypto::TEncryptMode
  else
    if i = 1
    then result instanceof Crypto::TDecryptMode
    else result instanceof Crypto::TUnknownKeyOperationMode
}

// TODO: need to add key consumer
abstract class EVP_Cipher_Initializer extends EVPInitialize {
  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }

  abstract Expr getOperationSubtypeArg();

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%")
    then result instanceof Crypto::TEncryptMode
    else
      if this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%")
      then result instanceof Crypto::TDecryptMode
      else
        if exists(getEncConfigValue(this.getOperationSubtypeArg()))
        then result = intToCipherOperationSubtype(getEncConfigValue(this.getOperationSubtypeArg()))
        else result instanceof Crypto::TUnknownKeyOperationMode
  }
}

abstract class EVP_EX_Initializer extends EVP_Cipher_Initializer {
  override Expr getKeyArg() { result = this.(Call).getArgument(3) }

  override Expr getIVArg() { result = this.(Call).getArgument(4) }
}

abstract class EVP_EX2_Initializer extends EVP_Cipher_Initializer {
  override Expr getKeyArg() { result = this.(Call).getArgument(2) }

  override Expr getIVArg() { result = this.(Call).getArgument(3) }
}

class EVP_Cipher_EX_Init_Call extends EVP_EX_Initializer {
  EVP_Cipher_EX_Init_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptInit_ex", "EVP_DecryptInit_ex", "EVP_CipherInit_ex"
      ]
  }

  override Expr getOperationSubtypeArg() {
    this.(Call).getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result = this.(Call).getArgument(5)
  }
}

class EVP_Cipher_EX2_or_Simple_Init_Call extends EVP_EX2_Initializer {
  EVP_Cipher_EX2_or_Simple_Init_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptInit_ex2", "EVP_DecryptInit_ex2", "EVP_CipherInit_ex2", "EVP_EncryptInit",
        "EVP_DecryptInit", "EVP_CipherInit"
      ]
  }

  override Expr getOperationSubtypeArg() {
    this.(Call).getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result = this.(Call).getArgument(4)
  }
}

class EVP_CipherInit_SKEY_Call extends EVP_EX2_Initializer {
  EVP_CipherInit_SKEY_Call() { this.(Call).getTarget().getName() in ["EVP_CipherInit_SKEY"] }

  override Expr getOperationSubtypeArg() { result = this.(Call).getArgument(5) }
}

class EVP_Cipher_Update_Call extends EVPUpdate {
  EVP_Cipher_Update_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptUpdate", "EVP_DecryptUpdate", "EVP_CipherUpdate"
      ]
  }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }
}

/**
 * see: https://docs.openssl.org/master/man3/EVP_EncryptInit/#synopsis
 * Base configuration for all EVP cipher operations.
 */
abstract class EVP_Cipher_Operation extends EVPOperation, Crypto::KeyOperationInstance {
  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    result instanceof Crypto::TEncryptMode and
    this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%")
    or
    result instanceof Crypto::TDecryptMode and
    this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%")
    or
    result = this.getInitCall().getKeyOperationSubtype() and
    this.(Call).getTarget().getName().toLowerCase().matches("%cipher%")
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    this.getInitCall().getIVArg() = result.asExpr()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    this.getInitCall().getKeyArg() = result.asExpr()
    // todo: or track to the EVP_PKEY_CTX_new
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = EVPOperation.super.getOutputArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = EVPOperation.super.getInputConsumer()
  }
}

class EVP_Cipher_Call extends EVPOperation, EVP_Cipher_Operation {
  EVP_Cipher_Call() { this.(Call).getTarget().getName() = "EVP_Cipher" }

  override Expr getInputArg() { result = this.(Call).getArgument(2) }

  override Expr getAlgorithmArg() { result = this.getInitCall().getAlgorithmArg() }
}

class EVP_Cipher_Final_Call extends EVPFinal, EVP_Cipher_Operation {
  EVP_Cipher_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_EncryptFinal_ex", "EVP_DecryptFinal_ex", "EVP_CipherFinal_ex", "EVP_EncryptFinal",
        "EVP_DecryptFinal", "EVP_CipherFinal"
      ]
  }

  /**
   * Output is both from update calls and from the final call.
   */
  override Expr getOutputArg() {
    result = EVPFinal.super.getOutputArg()
    or
    result = EVP_Cipher_Operation.super.getOutputArg()
  }

  override Expr getAlgorithmArg() { result = this.getInitCall().getAlgorithmArg() }
}
