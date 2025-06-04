private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import EVPCipherInitializer
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

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
}