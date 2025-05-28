/**
 * Provides classes for modeling OpenSSL's EVP signature operations
 */

private import experimental.quantum.Language
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow

// TODO: verification
class EVP_Cipher_Initializer extends EVPInitialize {
  EVP_Cipher_Initializer() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestSignInit", "EVP_DigestSignInit_ex", "EVP_SignInit", "EVP_SignInit_ex",
        "EVP_PKEY_sign_init", "EVP_PKEY_sign_init_ex", "EVP_PKEY_sign_init_ex2",
        "EVP_PKEY_sign_message_init"
      ]
  }

  override Expr getAlgorithmArg() {
    this.(Call).getTarget().getName() = "EVP_DigestSignInit" and
    result = this.(Call).getArgument(1)
    or
    this.(Call).getTarget().getName() = "EVP_DigestSignInit_ex" and
    result = this.(Call).getArgument(1)
    or
    this.(Call).getTarget().getName() = "EVP_PKEY_sign_init_ex2" and
    result = this.(Call).getArgument(1)
    or
    this.(Call).getTarget().getName() = "EVP_PKEY_sign_message_init" and
    result = this.(Call).getArgument(1)
  }

  override Expr getKeyArg() {
    this.(Call).getTarget().getName() = "EVP_DigestSignInit" and
    result = this.(Call).getArgument(4)
    or
    this.(Call).getTarget().getName() = "EVP_DigestSignInit_ex" and
    result = this.(Call).getArgument(5)
  }

  override Expr getIVArg() { none() }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if this.(Call).getTarget().getName().toLowerCase().matches("%sign%")
    then result instanceof Crypto::TSignMode
    else
      if this.(Call).getTarget().getName().toLowerCase().matches("%verify%")
      then result instanceof Crypto::TVerifyMode
      else result instanceof Crypto::TUnknownKeyOperationMode
  }
}

class EVP_Signature_Update_Call extends EVPUpdate {
  EVP_Signature_Update_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestSignUpdate", "EVP_SignUpdate", "EVP_PKEY_sign_message_update"
      ]
  }

  override Expr getInputArg() { result = this.(Call).getArgument(1) }
}

abstract class EVP_Signature_Operation extends EVPOperation, Crypto::KeyOperationInstance {
  EVP_Signature_Operation() { this.(Call).getTarget().getName().matches("EVP_%") }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if this.(Call).getTarget().getName().toLowerCase().matches("%sign%")
    then result instanceof Crypto::TSignMode
    else
      if this.(Call).getTarget().getName().toLowerCase().matches("%verify%")
      then result instanceof Crypto::TVerifyMode
      else result instanceof Crypto::TUnknownKeyOperationMode
  }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    // this.getInitCall().getIVArg() = result.asExpr()
    none()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    this.getInitCall().getKeyArg() = result.asExpr()
    // todo: or track to the EVP_PKEY_CTX_new
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = this.(EVPOperation).getOutputArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = this.(EVPOperation).getInputConsumer()
  }
}

class EVP_Signature_Call extends EVPOneShot, EVP_Signature_Operation {
  EVP_Signature_Call() { this.(Call).getTarget().getName() in ["EVP_DigestSign", "EVP_PKEY_sign"] }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }
}

class EVP_Signature_Final_Call extends EVPFinal, EVP_Signature_Operation {
  EVP_Signature_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestSignFinal", "EVP_SignFinal_ex", "EVP_SignFinal", "EVP_PKEY_sign_message_final"
      ]
  }
}
