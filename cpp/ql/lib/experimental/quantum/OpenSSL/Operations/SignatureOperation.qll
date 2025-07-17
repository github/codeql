/**
 * Provides classes for modeling OpenSSL's EVP signature operations
 */

private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AvcFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperations

// TODO: verification functions
/**
 * A base class for final signature operations.
 */
abstract class EvpSignatureFinalOperation extends OperationStep {
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
class EvpSignFinal extends EvpSignatureFinalOperation {
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
 * A call to EVP_DigestSign or EVP_PKEY_sign.
 */
class EvpDigestSign extends EvpSignatureFinalOperation {
  EvpDigestSign() { this.getTarget().getName() in ["EVP_DigestSign", "EVP_PKEY_sign"] }

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
 * A call to EVP_DigestSignFinal or EVP_PKEY_sign_message_final.
 */
class EvpDigestAndPkeySignFinal extends EvpSignatureFinalOperation {
  EvpDigestAndPkeySignFinal() {
    this.getTarget().getName() in [
        "EVP_DigestSignFinal",
        "EVP_PKEY_sign_message_final"
      ]
  }

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
 * An EVP signature operation instance.
 */
class EvpSignatureOperationInstance extends Crypto::SignatureOperationInstance instanceof EvpSignatureFinalOperation
{
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    super.getPrimaryAlgorithmValueConsumer() = result
  }

  /**
   * Signing, verification or unknown.
   */
  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    // TODO: if this KeyOperationSubtype does not match initialization call's KeyOperationSubtype then we found a bug
    if super.getTarget().getName().toLowerCase().matches("%sign%")
    then result instanceof Crypto::TSignMode
    else
      if super.getTarget().getName().toLowerCase().matches("%verify%")
      then result instanceof Crypto::TVerifyMode
      else result instanceof Crypto::TUnknownKeyOperationMode
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    // TODO: some signing operations may have explicit nonce generators
    none()
  }

  /**
   * Keys provided in the initialization call or in a context are found by this method.
   * Keys in explicit arguments are found by overridden methods in extending classes.
   */
  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    super.getDominatingInitializersToStep(KeyIO()).getInput(KeyIO()) = result
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    super.getOutputStepFlowingToStep(SignatureIO()).getOutput(SignatureIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    super.getDominatingInitializersToStep(PlaintextIO()).getInput(PlaintextIO()) = result
  }

  /**
   * TODO: only signing operations for now, change when verificaiton is added
   */
  override Crypto::ConsumerInputDataFlowNode getSignatureConsumer() { none() }

  override Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() {
    super
        .getDominatingInitializersToStep(HashAlgorithmIO())
        .getAlgorithmValueConsumerForInput(HashAlgorithmIO()) = result
  }
}
