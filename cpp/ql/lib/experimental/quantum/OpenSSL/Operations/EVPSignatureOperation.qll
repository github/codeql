/**
 * Provides classes for modeling OpenSSL's EVP signature operations
 */

private import experimental.quantum.Language
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.CtxFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.PKeyAlgorithmValueConsumer


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

  override Expr getAlgorithmArg() {
    if this.(Call).getTarget().getName() in ["EVP_PKEY_sign_init_ex2", "EVP_PKEY_sign_message_init"] then
      result = this.(Call).getArgument(1)
    else
      if isAlgorithmSpecifiedByKey = true then
        result = getAlgorithmFromKey(this.getKeyArg())
      else
        if isAlgorithmSpecifiedByCtx = true then
          result = getAlgorithmFromCtx(this.getContextArg())
        else
          none()
  }

  /**
   * Returns the key argument if there is one.
   * If the key was provided via the context, we track it to the context.
   */
  override Expr getKeyArg() {
    this.(Call).getTarget().getName() = "EVP_DigestSignInit" and
    result = this.(Call).getArgument(4)
    or
    this.(Call).getTarget().getName() = "EVP_DigestSignInit_ex" and
    result = this.(Call).getArgument(5)
    or
    this.(Call).getTarget().getName().matches("EVP_PKEY_%") and
    result = getKeyFromCtx(this.getContextArg())
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
    // NULL output argument means the call is to get the size of the signature and such call is not an operation
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

  /**
   * Keys provided in the initialization call or in a context are found by this method.
   * Keys in explicit arguments are found by overriden methods in extending classes.
   */
  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    result = DataFlow::exprNode(this.getInitCall().getKeyArg())
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

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    if this.(Call).getTarget().getName() in ["EVP_SignFinal", "EVP_SignFinal_ex"]
    then result = DataFlow::exprNode(this.(Call).getArgument(3))
    else result = EVP_Signature_Operation.super.getKeyConsumer()
  }

  /**
   * Output is the signature.
   */
  override Expr getOutputArg() { result = signatureOperationOutputArg(this) }
}
