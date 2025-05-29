/**
 * Provides classes for modeling OpenSSL's EVP signature operations
 */

private import experimental.quantum.Language
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow

// TODO: verification functions
class EVP_Signature_Initializer extends EVPInitialize {
  boolean isAlgorithmSpecifiedByKey;
  boolean isAlgorithmSpecifiedByCtx;

  EVP_Signature_Initializer() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestSignInit", "EVP_DigestSignInit_ex", "EVP_SignInit", "EVP_SignInit_ex",
        "EVP_PKEY_sign_init", "EVP_PKEY_sign_init_ex", "EVP_PKEY_sign_init_ex2",
        "EVP_PKEY_sign_message_init"
      ] and
    (
      if this.(Call).getTarget().getName().matches("EVP_PKEY_%")
      then isAlgorithmSpecifiedByKey = false
      else isAlgorithmSpecifiedByKey = true
    ) and
    (
      if this.(Call).getTarget().getName() in ["EVP_PKEY_sign_init", "EVP_PKEY_sign_init_ex"]
      then isAlgorithmSpecifiedByCtx = true
      else isAlgorithmSpecifiedByCtx = false
    )
  }

  /**
   * Returns the argument that specifies the algorithm or none if the algorithm is implicit (from context or from key).
   * Note that the key may be not provided in the initialization call.
   */
  override Expr getAlgorithmArg() {
    if isAlgorithmSpecifiedByKey = true or isAlgorithmSpecifiedByCtx = true
    then none()
    else (
      this.(Call).getTarget().getName() in ["EVP_PKEY_sign_init_ex2", "EVP_PKEY_sign_message_init"] and
      result = this.(Call).getArgument(1)
    )
  }

  /**
   * Returns the key argument if there is one.
   * They key could be provided in the context or in a later call (final or one-shot).
   */
  override Expr getKeyArg() {
    this.(Call).getTarget().getName() = "EVP_DigestSignInit" and
    result = this.(Call).getArgument(4)
    or
    this.(Call).getTarget().getName() = "EVP_DigestSignInit_ex" and
    result = this.(Call).getArgument(5)
  }

  /**
   * Signing, verification or unknown.
   */
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

  /**
   * Input is the message to sign.
   */
  override Expr getInputArg() { result = this.(Call).getArgument(1) }
}

/**
 * We model output explicit output arguments as predicate to use it in constructors.
 * The predicate must cover all EVP_Signature_Operation subclasses.
 */
private Expr signatureOperationOutputArg(Call call) {
  if call.getTarget().getName() = "EVP_SignFinal_ex"
  then result = call.getArgument(2)
  else result = call.getArgument(1)
}

/**
 * Base configuration for all EVP signature operations.
 */
abstract class EVP_Signature_Operation extends EVPOperation, Crypto::SignatureOperationInstance {
  EVP_Signature_Operation() {
    this.(Call).getTarget().getName().matches("EVP_%") and
    // NULL output argument means the call is to get the size of the signature
    (
      not exists(signatureOperationOutputArg(this).getValue())
      or
      signatureOperationOutputArg(this).getValue() != "0"
    )
  }

  /**
   * Signing, verification or unknown.
   */
  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    // TODO: if this KeyOperationSubtype does not match initialization call's KeyOperationSubtype then we found a bug
    if this.(Call).getTarget().getName().toLowerCase().matches("%sign%")
    then result instanceof Crypto::TSignMode
    else
      if this.(Call).getTarget().getName().toLowerCase().matches("%verify%")
      then result instanceof Crypto::TVerifyMode
      else result instanceof Crypto::TUnknownKeyOperationMode
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    // TODO: some signing operations may have explicit nonce generators
    none()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    result = DataFlow::exprNode(this.getInitCall().getKeyArg())
    // TODO: or track to the EVP_PKEY_CTX_new
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = EVPOperation.super.getOutputArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = EVPOperation.super.getInputConsumer()
  }

  /**
   * TODO: only signing operations for now, change when verificaiton is added
   */
  override Crypto::ConsumerInputDataFlowNode getSignatureConsumer() { none() }

}

class EVP_Signature_Call extends EVPOperation, EVP_Signature_Operation {
  EVP_Signature_Call() { this.(Call).getTarget().getName() in ["EVP_DigestSign", "EVP_PKEY_sign"] }

  /**
   * Output is the signature.
   */
  override Expr getOutputArg() { result = signatureOperationOutputArg(this) }

  /**
   * Input is the message to sign.
   */
  override Expr getInputArg() { result = this.(Call).getArgument(3) }
}

class EVP_Signature_Final_Call extends EVPFinal, EVP_Signature_Operation {
  EVP_Signature_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestSignFinal", "EVP_SignFinal_ex", "EVP_SignFinal", "EVP_PKEY_sign_message_final"
      ]
  }

  /**
   * Output is the signature.
   */
  override Expr getOutputArg() { result = signatureOperationOutputArg(this) }
}
