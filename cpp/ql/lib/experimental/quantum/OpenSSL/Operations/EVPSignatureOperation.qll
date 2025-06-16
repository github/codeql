/**
 * Provides classes for modeling OpenSSL's EVP signature operations
 */

private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AvcFlow
private import experimental.quantum.OpenSSL.CtxFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperations

// TODO: verification functions
class EvpSignatureDigestInitializer extends EvpHashAlgorithmInitializer {
  Expr arg;

  EvpSignatureDigestInitializer() {
    this.(Call).getTarget().getName() in ["EVP_DigestSignInit_ex", "EVP_DigestSignInit"] and
    arg = this.(Call).getArgument(2)
    or
    this.(Call).getTarget().getName() in ["EVP_SignInit", "EVP_SignInit_ex"] and
    arg = this.(Call).getArgument(1)
  }

  override Expr getHashAlgorithmArg() { result = arg }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EvpSignatureKeyInitializer extends EvpKeyInitializer {
  Expr arg;

  EvpSignatureKeyInitializer() {
    this.(Call).getTarget().getName() = "EVP_DigestSignInit_ex" and
    arg = this.(Call).getArgument(5)
    or
    this.(Call).getTarget().getName() = "EVP_DigestSignInit" and
    arg = this.(Call).getArgument(4)
  }

  override Expr getKeyArg() { result = arg }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EvpSignaturePrimaryAlgorithmInitializer extends EvpPrimaryAlgorithmInitializer {
  Expr arg;

  EvpSignaturePrimaryAlgorithmInitializer() {
    // signature algorithm
    this.(Call).getTarget().getName() in ["EVP_PKEY_sign_init_ex2", "EVP_PKEY_sign_message_init"] and
    arg = this.(Call).getArgument(1)
    or
    // configuration through the context argument
    this.(Call).getTarget().getName() in ["EVP_PKEY_sign_init", "EVP_PKEY_sign_init_ex"] and
    arg = this.getContext()
  }

  override Expr getAlgorithmArg() { result = arg }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class Evp_Signature_Update_Call extends EvpUpdate {
  Evp_Signature_Update_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestSignUpdate", "EVP_SignUpdate", "EVP_PKEY_sign_message_update"
      ]
  }

  /**
   * Input is the message to sign.
   */
  override Expr getInputArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

/**
 * We model output explicit output arguments as predicate to use it in constructors.
 * The predicate must cover all EVP_Signature_Operation subclasses.
 */
pragma[inline]
private Expr signatureOperationOutputArg(Call call) {
  if call.getTarget().getName() = "EVP_SignFinal_ex"
  then result = call.getArgument(2)
  else result = call.getArgument(1)
}

/**
 * The base configuration for all EVP signature operations.
 */
abstract class EvpSignatureOperation extends EvpOperation, Crypto::SignatureOperationInstance {
  EvpSignatureOperation() {
    this.(Call).getTarget().getName().matches("EVP_%") and
    // NULL output argument means the call is to get the size of the signature and such call is not an operation
    (
      not exists(signatureOperationOutputArg(this).getValue())
      or
      signatureOperationOutputArg(this).getValue() != "0"
    )
  }

  Expr getHashAlgorithmArg() {
    this.getInitCall().(EvpHashAlgorithmInitializer).getHashAlgorithmArg() = result
  }

  override Expr getAlgorithmArg() {
    this.getInitCall().(EvpPrimaryAlgorithmInitializer).getAlgorithmArg() = result
  }

  override Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() {
    AvcToCallArgFlow::flow(result.(OpenSslAlgorithmValueConsumer).getResultNode(),
      DataFlow::exprNode(this.getHashAlgorithmArg()))
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
    result = DataFlow::exprNode(this.getInitCall().(EvpKeyInitializer).getKeyArg())
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = EvpOperation.super.getOutputArtifact()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = EvpOperation.super.getInputConsumer()
  }

  /**
   * TODO: only signing operations for now, change when verificaiton is added
   */
  override Crypto::ConsumerInputDataFlowNode getSignatureConsumer() { none() }
}

class Evp_Signature_Call extends EvpSignatureOperation {
  Evp_Signature_Call() { this.(Call).getTarget().getName() in ["EVP_DigestSign", "EVP_PKEY_sign"] }

  /**
   * Output is the signature.
   */
  override Expr getOutputArg() { result = signatureOperationOutputArg(this) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }

  /**
   * Input is the message to sign.
   */
  override Expr getInputArg() { result = this.(Call).getArgument(3) }
}

class Evp_Signature_Final_Call extends EvpFinal, EvpSignatureOperation {
  Evp_Signature_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestSignFinal",
        "EVP_SignFinal_ex",
        "EVP_SignFinal",
        "EVP_PKEY_sign_message_final"
      ]
  }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }

  override Expr getAlgorithmArg() {
    this.getInitCall().(EvpPrimaryAlgorithmInitializer).getAlgorithmArg() = result
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    // key provided as an argument
    this.(Call).getTarget().getName() in ["EVP_SignFinal", "EVP_SignFinal_ex"] and
    result = DataFlow::exprNode(this.(Call).getArgument(3))
    or
    // or find key in the initialization call
    result = EvpSignatureOperation.super.getKeyConsumer()
  }

  /**
   * Output is the signature.
   */
  override Expr getOutputArg() { result = signatureOperationOutputArg(this) }
}
