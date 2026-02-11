/**
 * Provides classes for modeling OpenSSL's EVP signature operations
 */

private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AvcFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperations
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances

/**
 * A base class for final signature operations.
 * The operation must be known to always be a signature operation,
 * and not a MAC operation. Used for both verification and signing.
 * NOTE: even an operation that may be a mac or signature but is known to take in
 * only signature configurations should extend `SignatureOrMacFinalOperation`.
 */
abstract class SignatureFinalOperation extends OperationStep {
  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * A base class for final signature or MAC operations.
 * The operation must be known to always be a signature or MAC operation.
 * Used for both verification or signing.
 */
abstract class SignatureOrMacFinalOperation extends OperationStep {
  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * A call to EVP_DigestSignInit or EVP_DigestSignInit_ex.
 */
class EvpSignatureDigestInitializer extends OperationStep {
  EvpSignatureDigestInitializer() {
    this.getTarget().getName() in ["EVP_DigestSignInit_ex", "EVP_DigestSignInit"]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit_ex" and
    result.asIndirectExpr() = this.getArgument(3) and
    type = OsslLibContextIO()
    or
    result.asIndirectExpr() = this.getArgument(2) and type = HashAlgorithmIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit" and
    result.asIndirectExpr() = this.getArgument(4) and
    type = KeyIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit_ex" and
    result.asIndirectExpr() = this.getArgument(5) and
    type = KeyIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit_ex" and
    result.asIndirectExpr() = this.getArgument(6) and
    type = OsslParamIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
    or
    // EVP_PKEY_CTX
    result.asDefiningArgument() = this.getArgument(1) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to EVP_SignInit or EVP_SignInit_ex.
 */
class EvpSignInit extends OperationStep {
  EvpSignInit() { this.getTarget().getName() in ["EVP_SignInit", "EVP_SignInit_ex"] }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = HashAlgorithmIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to:
 * - EVP_PKEY_sign_init_ex
 * - EVP_PKEY_sign_init_ex2
 * - EVP_PKEY_sign_init
 * - EVP_PKEY_sign_message_init
 */
class EvpPkeySignInit extends OperationStep {
  EvpPkeySignInit() {
    this.getTarget().getName() in [
        "EVP_PKEY_sign_init_ex", "EVP_PKEY_sign_init_ex2", "EVP_PKEY_sign_init",
        "EVP_PKEY_sign_message_init"
      ]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    this.getTarget().getName() in ["EVP_PKEY_sign_init_ex2", "EVP_PKEY_sign_message_init"] and
    result.asIndirectExpr() = this.getArgument(1) and
    type = PrimaryAlgorithmIO()
    or
    this.getTarget().getName() = "EVP_PKEY_sign_init_ex" and
    result.asIndirectExpr() = this.getArgument(1) and
    type = OsslParamIO()
    or
    // Argument 2 (0 based) only exists for EVP_PKEY_sign_init_ex2 and EVP_PKEY_sign_message_init
    result.asIndirectExpr() = this.getArgument(2) and type = OsslParamIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to EVP_DIgestSignUpdate, EVP_SignUpdate or EVP_PKEY_sign_message_update.
 */
class EvpSignatureUpdateCall extends OperationStep {
  EvpSignatureUpdateCall() {
    this.getTarget().getName() in [
        "EVP_DigestSignUpdate", "EVP_SignUpdate", "EVP_PKEY_sign_message_update"
      ]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = UpdateStep() }
}

/**
 * A call to EVP_SignFinal or EVP_SignFinal_ex.
 */
class EvpSignFinal extends SignatureFinalOperation {
  EvpSignFinal() { this.getTarget().getName() in ["EVP_SignFinal_ex", "EVP_SignFinal"] }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(3) and type = KeyIO()
    or
    // params above 3 (0-based) only exist for EVP_SignFinal_ex
    result.asIndirectExpr() = this.getArgument(4) and
    type = OsslLibContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
    or
    result.asDefiningArgument() = this.getArgument(1) and type = SignatureIO()
    or
    result.asDefiningArgument() = this.getArgument(2) and type = SignatureSizeIO()
  }
}

/**
 * A call to EVP_PKEY_sign.
 */
class EvpPkeySign extends SignatureFinalOperation {
  EvpPkeySign() {
    this.getTarget().getName() = "EVP_PKEY_sign" and
    // Setting signature to NULL is not a final sign step but an
    // intermediary step used to get the required buffer size.
    // not tracking these calls.
    (
      exists(this.(Call).getArgument(1).getValue())
      implies
      this.(Call).getArgument(1).getValue().toInt() != 0
    )
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
    or
    result.asDefiningArgument() = this.getArgument(1) and type = SignatureIO()
  }
}

/**
 * A call to EVP_DigestSign.
 * This is a mac or sign operation.
 */
class EvpDigestSign extends SignatureOrMacFinalOperation {
  EvpDigestSign() { this.getTarget().getName() = "EVP_DigestSign" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
    or
    result.asDefiningArgument() = this.getArgument(1) and type = SignatureIO()
  }
}

/**
 * A call to EVP_PKEY_sign_message_final.
 */
class EvpPkeySignFinal extends SignatureFinalOperation {
  EvpPkeySignFinal() {
    this.getTarget().getName() = "EVP_PKEY_sign_message_final" and
    // Setting signature to NULL is not a final sign step but an
    // intermediary step used to get the required buffer size.
    // not tracking these calls.
    (
      exists(this.(Call).getArgument(1).getValue())
      implies
      this.(Call).getArgument(1).getValue().toInt() != 0
    )
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
    or
    result.asDefiningArgument() = this.getArgument(1) and type = SignatureIO()
    or
    result.asExpr() = this.getArgument(2) and type = SignatureSizeIO()
  }
}

/**
 * A call to EVP_DigestSignFinal.
 * This is a mac or sign operation.
 */
class EvpDigestSignFinal extends SignatureOrMacFinalOperation {
  EvpDigestSignFinal() {
    this.getTarget().getName() = "EVP_DigestSignFinal" and
    // Setting signature to NULL is not a final sign step but an
    // intermediary step used to get the required buffer size.
    // not tracking these calls.
    (
      exists(this.(Call).getArgument(1).getValue())
      implies
      this.(Call).getArgument(1).getValue().toInt() != 0
    )
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
    or
    result.asDefiningArgument() = this.getArgument(1) and type = SignatureIO()
  }

  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * A call to EVP_DigestVerifyInit or EVP_DigestVerifyInit_ex.
 */
class EvpDigestVerifyInit extends OperationStep {
  EvpDigestVerifyInit() {
    this.getTarget().getName() in ["EVP_DigestVerifyInit", "EVP_DigestVerifyInit_ex"]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(2) and type = HashAlgorithmIO()
    or
    this.getTarget().getName() = "EVP_DigestVerifyInit_ex" and
    result.asIndirectExpr() = this.getArgument(3) and
    type = OsslLibContextIO()
    or
    this.getTarget().getName() = "EVP_DigestVerifyInit_ex" and
    result.asIndirectExpr() = this.getArgument(5) and
    type = KeyIO()
    or
    this.getTarget().getName() = "EVP_DigestVerifyInit" and
    result.asIndirectExpr() = this.getArgument(4) and
    type = KeyIO()
    or
    this.getTarget().getName() = "EVP_DigestVerifyInit_ex" and
    result.asIndirectExpr() = this.getArgument(6) and
    type = OsslParamIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
    or
    result.asDefiningArgument() = this.getArgument(1) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to EVP_DigestVerifyUpdate.
 */
class EvpDigestVerifyUpdate extends OperationStep {
  EvpDigestVerifyUpdate() { this.getTarget().getName() = "EVP_DigestVerifyUpdate" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = UpdateStep() }
}

/**
 * A call to EVP_DigestVerifyFinal
 */
class EvpDigestVerifyFinal extends SignatureFinalOperation {
  EvpDigestVerifyFinal() { this.getTarget().getName() = "EVP_DigestVerifyFinal" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = SignatureIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }
}

/**
 * A call to EVP_DigestVerify
 */
class EvpDigestVerify extends SignatureFinalOperation {
  EvpDigestVerify() { this.getTarget().getName() = "EVP_DigestVerify" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = SignatureIO()
    or
    result.asIndirectExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }
}

/**
 * A call to `EVP_PKEY_verify_init`, `EVP_PKEY_verify_init_ex`,
 * `EVP_PKEY_verify_init_ex2`, or `EVP_PKEY_verify_message_init`
 * https://docs.openssl.org/master/man3/EVP_PKEY_verify/#synopsis
 */
class EvpVerifyInit extends OperationStep {
  EvpVerifyInit() {
    this.getTarget().getName() in [
        "EVP_PKEY_verify_init", "EVP_PKEY_verify_init_ex", "EVP_PKEY_verify_init_ex2",
        "EVP_PKEY_verify_message_init"
      ]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    this.getTarget().getName() = "EVP_PKEY_verify_init_ex" and
    result.asIndirectExpr() = this.getArgument(1) and
    type = OsslParamIO()
    or
    this.getTarget().getName() in ["EVP_PKEY_verify_init_ex2", "EVP_PKEY_verify_message_init"] and
    result.asIndirectExpr() = this.getArgument(1) and
    type = PrimaryAlgorithmIO()
    or
    this.getTarget().getName() in ["EVP_PKEY_verify_init_ex2", "EVP_PKEY_verify_message_init"] and
    result.asIndirectExpr() = this.getArgument(2) and
    type = OsslParamIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to `EVP_PKEY_CTX_set_signature`
 * https://docs.openssl.org/master/man3/EVP_PKEY_verify/
 */
class EvpCtxSetSignatureInitializer extends OperationStep {
  EvpCtxSetSignatureInitializer() { this.getTarget().getName() = "EVP_PKEY_CTX_set_signature" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = SignatureIO()
    or
    result.asExpr() = this.getArgument(2) and type = SignatureSizeIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to `EVP_PKEY_verify_message_update`.
 */
class EvpVerifyMessageUpdate extends OperationStep {
  EvpVerifyMessageUpdate() { this.getTarget().getName() = "EVP_PKEY_verify_message_update" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = PlaintextIO()
    or
    result.asExpr() = this.getArgument(2) and type = PlaintextSizeIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = UpdateStep() }
}

/**
 * A call to `EVP_PKEY_verify_message_final`.
 */
class EvpVerifyMessageFinal extends SignatureFinalOperation {
  EvpVerifyMessageFinal() { this.getTarget().getName() = "EVP_PKEY_verify_message_final" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }
}

/**
 * A call to `EVP_PKEY_verify`
 */
class EvpVerify extends SignatureFinalOperation {
  EvpVerify() { this.getTarget().getName() = "EVP_PKEY_verify" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = SignatureIO()
    or
    result.asExpr() = this.getArgument(2) and type = SignatureSizeIO()
    or
    result.asIndirectExpr() = this.getArgument(3) and type = PlaintextIO()
    or
    result.asExpr() = this.getArgument(4) and type = PlaintextSizeIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }
}

/**
 * A call to `RSA_sign` or `RSA_verify`.
 * https://docs.openssl.org/3.0/man3/RSA_sign/
 */
class RsaSignorVerify extends SignatureFinalOperation {
  RsaSignorVerify() { this.getTarget().getName() in ["RSA_sign", "RSA_verify"] }

  override DataFlow::Node getInput(IOType type) {
    // Arg 0 is an NID (so asExpr not asIndirectExpr)
    result.asExpr() = this.getArgument(0) and type = HashAlgorithmIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = PlaintextIO()
    or
    result.asExpr() = this.getArgument(2) and type = PlaintextSizeIO()
    or
    this.getTarget().getName() = "RSA_verify" and
    result.asIndirectExpr() = this.getArgument(3) and
    type = SignatureIO()
    or
    this.getTarget().getName() = "RSA_verify" and
    result.asIndirectExpr() = this.getArgument(4) and
    type = SignatureSizeIO()
    or
    result.asIndirectExpr() = this.getArgument(5) and type = KeyIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
    or
    this.getTarget().getName() = "RSA_sign" and
    result.asDefiningArgument() = this.getArgument(3) and
    type = SignatureIO()
    or
    this.getTarget().getName() = "RSA_sign" and
    type = SignatureSizeIO() and
    result.asDefiningArgument() = this.getArgument(4)
  }
}

/**
 * A call to `DSA_do_sign` or `DSA_do_verify`
 */
class DsaDoSignOrVerify extends SignatureFinalOperation {
  DsaDoSignOrVerify() { this.getTarget().getName() in ["DSA_do_sign", "DSA_do_verify"] }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = PlaintextIO()
    or
    result.asExpr() = this.getArgument(1) and type = PlaintextSizeIO()
    or
    this.getTarget().getName() = "DSA_do_sign" and
    result.asIndirectExpr() = this.getArgument(2) and
    type = KeyIO()
    or
    this.getTarget().getName() = "DSA_do_verify" and
    result.asIndirectExpr() = this.getArgument(2) and
    type = SignatureIO()
    or
    this.getTarget().getName() = "DSA_do_verify" and
    result.asIndirectExpr() = this.getArgument(3) and
    type = KeyIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    this.getTarget().getName() = "DSA_do_sign" and
    result.asIndirectExpr() = this and
    type = SignatureIO()
  }
}

/**
 * A Call to `EVP_VerifyInit` or `EVP_VerifyInit_ex`
 * - int EVP_VerifyInit_ex(EVP_MD_CTX *ctx, const EVP_MD *type, ENGINE *impl);
 * - int EVP_VerifyInit(EVP_MD_CTX *ctx, const EVP_MD *type);
 */
class EVP_VerifyInitCall extends OperationStep {
  EVP_VerifyInitCall() { this.getTarget().getName() in ["EVP_VerifyInit", "EVP_VerifyInit_ex"] }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = HashAlgorithmIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to `EVP_VerifyUpdate`
 * - int EVP_VerifyUpdate(EVP_MD_CTX *ctx, const void *d, unsigned int cnt);
 */
class EVP_VerifyUpdateCall extends OperationStep {
  EVP_VerifyUpdateCall() { this.getTarget().getName() = "EVP_VerifyUpdate" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = PlaintextIO()
    or
    result.asIndirectExpr() = this.getArgument(2) and type = PlaintextSizeIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = UpdateStep() }
}

/**
 * A call to `EVP_VerifyFinal` or `EVP_VerifyFinal_ex`
 * - int EVP_VerifyFinal_ex(EVP_MD_CTX *ctx, const unsigned char *sigbuf,
 *                       unsigned int siglen, EVP_PKEY *pkey,
 *                       OSSL_LIB_CTX *libctx, const char *propq);
 *- int EVP_VerifyFinal(EVP_MD_CTX *ctx, unsigned char *sigbuf, unsigned int siglen,
 *                    EVP_PKEY *pkey);                       *
 */
class EVP_VerifyFinalCall extends SignatureFinalOperation {
  EVP_VerifyFinalCall() { this.getTarget().getName() in ["EVP_VerifyFinal", "EVP_VerifyFinal_ex"] }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = SignatureIO()
    or
    result.asExpr() = this.getArgument(2) and type = SignatureSizeIO()
    or
    result.asIndirectExpr() = this.getArgument(3) and type = KeyIO()
    or
    result.asIndirectExpr() = this.getArgument(4) and type = OsslLibContextIO()
    // TODO: arg 5 propq?
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * An instance of a signature operation.
 * This is an OpenSSL specific class that extends the base SignatureOperationInstance.
 */
class OpenSslSignatureOperationInstance extends Crypto::SignatureOperationInstance instanceof SignatureFinalOperation
{
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    super.getPrimaryAlgorithmValueConsumer() = result
  }

  /**
   * Signing, verification or unknown.
   */
  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    // NOTE: if this KeyOperationSubtype does not match initialization call's KeyOperationSubtype then we found a bug
    if super.getTarget().getName().toLowerCase().matches("%sign%")
    then result instanceof Crypto::TSignMode
    else
      if super.getTarget().getName().toLowerCase().matches("%verify%")
      then result instanceof Crypto::TVerifyMode
      else result instanceof Crypto::TUnknownKeyOperationMode
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    // some signing operations may have explicit nonce generators
    super.getDominatingInitializersToStep(IVorNonceIO()).getInput(IVorNonceIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    super.getDominatingInitializersToStep(KeyIO()).getInput(KeyIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getSignatureConsumer() {
    super.getDominatingInitializersToStep(SignatureIO()).getInput(SignatureIO()) = result
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    super.getOutputStepFlowingToStep(SignatureIO()).getOutput(SignatureIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    super.getDominatingInitializersToStep(PlaintextIO()).getInput(PlaintextIO()) = result
  }

  override Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() {
    super
        .getDominatingInitializersToStep(HashAlgorithmIO())
        .getAlgorithmValueConsumerForInput(HashAlgorithmIO()) = result
    or
    // Handle cases where the hash is set through the primary algorithm
    // RSA-SHA256 for example
    // NOTE: assuming the hash would not be overridden, or if it is it is undefined
    // i.e., if the above dominating initializer exists and the primary algorithm
    // specifies a hash, consider both valid hash AVCs.
    // TODO: can this behavior be build into the get dominating initializers?
    super.getPrimaryAlgorithmValueConsumer() = result and
    exists(OpenSslAlgorithmInstance i |
      i.getAvc() = result and i instanceof Crypto::HashAlgorithmInstance
    )
  }

  override predicate hasHashAlgorithmConsumer() {
    exists(super.getDominatingInitializersToStep(HashAlgorithmIO()))
  }
}

/**
 * A class for signature or MAC operation instances.
 * This is an OpenSSL specific class that extends the base SignatureOrMacOperationInstance.
 */
class OpenSslSignatureOrMacOperationInstance extends Crypto::SignatureOrMacOperationInstance instanceof SignatureOrMacFinalOperation
{
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    super.getPrimaryAlgorithmValueConsumer() = result
  }

  /**
   * Signing, verification or unknown.
   */
  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    result instanceof Crypto::TSignMode or result instanceof Crypto::TMacMode
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    // some signing operations may have explicit nonce generators
    super.getDominatingInitializersToStep(IVorNonceIO()).getInput(IVorNonceIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    super.getDominatingInitializersToStep(KeyIO()).getInput(KeyIO()) = result
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    super.getOutputStepFlowingToStep(SignatureIO()).getOutput(SignatureIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    super.getDominatingInitializersToStep(PlaintextIO()).getInput(PlaintextIO()) = result
  }

  override Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() {
    super
        .getDominatingInitializersToStep(HashAlgorithmIO())
        .getAlgorithmValueConsumerForInput(HashAlgorithmIO()) = result
    or
    // Handle cases where the hash is set through the primary algorithm
    // RSA-SHA256 for example
    // NOTE: assuming the hash would not be overridden, or if it is it is undefined
    // i.e., if the above dominating initializer exists and the primary algorithm
    // specifies a hash, consider both valid hash AVCs.
    // TODO: can this behavior be build into the get dominating initializers?
    super.getPrimaryAlgorithmValueConsumer() = result and
    exists(OpenSslAlgorithmInstance i |
      i.getAvc() = result and i instanceof Crypto::HashAlgorithmInstance
    )
  }

  override predicate hasHashAlgorithmConsumer() {
    exists(super.getDominatingInitializersToStep(HashAlgorithmIO()))
  }
}
