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
 * and not a MAC operation.
 * NOTE: even an operation that may be a mac or signature but is known to take in
 * only signature configurations should extend `SignatureOrMacFinalOperation`.
 */
abstract class SignatureFinalOperation extends OperationStep {
  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * A base class for final signature or MAC operations.
 * The operation must be known to always be a signature or MAC operation.
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
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit_ex" and
    result.asExpr() = this.getArgument(3) and
    type = OsslLibContextIO()
    or
    result.asExpr() = this.getArgument(2) and type = HashAlgorithmIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit" and
    result.asExpr() = this.getArgument(4) and
    type = KeyIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit_ex" and
    result.asExpr() = this.getArgument(5) and
    type = KeyIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit_ex" and
    result.asExpr() = this.getArgument(6) and
    type = OsslParamIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    // EVP_PKEY_CTX
    result.asExpr() = this.getArgument(1) and type = ContextIO()
    or
    this.getTarget().getName() = "EVP_DigestSignInit_ex" and
    result.asExpr() = this.getArgument(6) and
    type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to EVP_SignInit or EVP_SignInit_ex.
 */
class EvpSignInit extends OperationStep {
  EvpSignInit() { this.getTarget().getName() in ["EVP_SignInit", "EVP_SignInit_ex"] }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = HashAlgorithmIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
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
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    this.getTarget().getName() in ["EVP_PKEY_sign_init_ex2", "EVP_PKEY_sign_message_init"] and
    result.asExpr() = this.getArgument(1) and
    type = PrimaryAlgorithmIO()
    or
    this.getTarget().getName() = "EVP_PKEY_sign_init_ex" and
    result.asExpr() = this.getArgument(1) and
    type = OsslParamIO()
    or
    // Argument 2 (0 based) only exists for EVP_PKEY_sign_init_ex2 and EVP_PKEY_sign_message_init
    result.asExpr() = this.getArgument(2) and type = OsslParamIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
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
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = UpdateStep() }
}

/**
 * A call to EVP_SignFinal or EVP_SignFinal_ex.
 */
class EvpSignFinal extends SignatureFinalOperation {
  EvpSignFinal() { this.getTarget().getName() in ["EVP_SignFinal_ex", "EVP_SignFinal"] }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(3) and type = KeyIO()
    or
    // params above 3 (0-based) only exist for EVP_SignFinal_ex
    result.asExpr() = this.getArgument(4) and
    type = OsslLibContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = SignatureIO()
  }
}

/**
 * A call to EVP_PKEY_sign.
 */
class EvpPkeySign extends SignatureFinalOperation {
  EvpPkeySign() { this.getTarget().getName() = "EVP_PKEY_sign" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = SignatureIO()
  }
}

/**
 * A call to EVP_DigestSign.
 * This is a mac or sign operation.
 */
class EvpDigestSign extends SignatureOrMacFinalOperation {
  EvpDigestSign() { this.getTarget().getName() = "EVP_DigestSign" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = SignatureIO()
  }
}

/**
 * A call to EVP_PKEY_sign_message_final.
 */
class EvpPkeySignFinal extends SignatureFinalOperation {
  EvpPkeySignFinal() { this.getTarget().getName() = "EVP_PKEY_sign_message_final" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = SignatureIO()
  }

  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * A call to EVP_DigestSignFinal.
 * This is a mac or sign operation.
 */
class EvpDigestSignFinal extends SignatureOrMacFinalOperation {
  EvpDigestSignFinal() { this.getTarget().getName() = "EVP_DigestSignFinal" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = SignatureIO()
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
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(2) and type = HashAlgorithmIO()
    or
    this.getTarget().getName() = "EVP_DigestVerifyInit_ex" and
    result.asExpr() = this.getArgument(3) and
    type = OsslLibContextIO()
    or
    this.getTarget().getName() = "EVP_DigestVerifyInit_ex" and
    result.asExpr() = this.getArgument(5) and
    type = KeyIO()
    or
    this.getTarget().getName() = "EVP_DigestVerifyInit" and
    result.asExpr() = this.getArgument(4) and
    type = KeyIO()
    or
    this.getTarget().getName() = "EVP_DigestVerifyInit_ex" and
    result.asExpr() = this.getArgument(6) and
    type = OsslParamIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to EVP_DigestVerifyUpdate.
 */
class EvpDigestVerifyUpdate extends OperationStep {
  EvpDigestVerifyUpdate() { this.getTarget().getName() = "EVP_DigestVerifyUpdate" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = UpdateStep() }
}

/**
 * A call to EVP_DigestVerifyFinal
 */
class EvpDigestVerifyFinal extends SignatureFinalOperation {
  EvpDigestVerifyFinal() { this.getTarget().getName() = "EVP_DigestVerifyFinal" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = SignatureIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }
}

/**
 * A call to EVP_DigestVerify
 */
class EvpDigestVerify extends SignatureFinalOperation {
  EvpDigestVerify() { this.getTarget().getName() = "EVP_DigestVerify" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = SignatureIO()
    or
    result.asExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }
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
  }

  override predicate hasHashAlgorithmConsumer() {
    exists(super.getDominatingInitializersToStep(HashAlgorithmIO()))
  }
}
