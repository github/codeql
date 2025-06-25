import experimental.quantum.Language
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
import EVPPKeyCtxInitializer

/**
 * A base class for all EVP cipher operations.
 */
abstract class EvpCipherInitializer extends OperationStep {
  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and
    type = PrimaryAlgorithmIO() and
    // Null for the algorithm indicates the algorithm is not actually set
    // This pattern can occur during a multi-step initialization
    // TODO/Note: not flowing 0 to the sink, assuming a direct use of NULL for now
    (exists(result.asExpr().getValue()) implies result.asExpr().getValue().toInt() != 0)
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A base class for EVP cipher/decrypt/encrypt 'ex' operations.
 */
abstract class EvpEXInitializer extends EvpCipherInitializer {
  override DataFlow::Node getInput(IOType type) {
    result = super.getInput(type)
    or
    (
      // Null key or nonce indicates the key/nonce is not actually set
      // This pattern can occur during a multi-step initialization
      // TODO/Note: not flowing 0 to the sink, assuming a direct use of NULL for now
      result.asExpr() = this.getArgument(3) and type = KeyIO()
      or
      result.asExpr() = this.getArgument(4) and type = IVorNonceIO()
    ) and
    (exists(result.asExpr().getValue()) implies result.asExpr().getValue().toInt() != 0)
  }
}

/**
 * A base class for EVP cipher/decrypt/encrypt 'ex2' operations.
 */
abstract class EvpEX2Initializer extends EvpCipherInitializer {
  override DataFlow::Node getInput(IOType type) {
    result = super.getInput(type)
    or
    result.asExpr() = this.getArgument(2) and type = KeyIO()
    or
    result.asExpr() = this.getArgument(3) and type = IVorNonceIO()
  }
}

/**
 * A Call to an EVP Cipher/Encrypt/Decrypt initialization operation.
 */
class EvpCipherEXInitCall extends EvpEXInitializer {
  EvpCipherEXInitCall() {
    this.getTarget().getName() in ["EVP_EncryptInit_ex", "EVP_DecryptInit_ex", "EVP_CipherInit_ex"]
  }

  override DataFlow::Node getInput(IOType type) {
    result = super.getInput(type)
    or
    // NOTE: for EncryptInit and DecryptInit there is no subtype arg
    // the subtype is determined automatically by the initializer based on the operation name
    this.getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result.asExpr() = this.getArgument(5) and
    type = KeyOperationSubtypeIO()
  }
}

class Evp_Cipher_EX2_or_Simple_Init_Call extends EvpEX2Initializer {
  Evp_Cipher_EX2_or_Simple_Init_Call() {
    this.getTarget().getName() in [
        "EVP_EncryptInit_ex2", "EVP_DecryptInit_ex2", "EVP_CipherInit_ex2", "EVP_EncryptInit",
        "EVP_DecryptInit", "EVP_CipherInit"
      ]
  }

  override DataFlow::Node getInput(IOType type) {
    result = super.getInput(type)
    or
    this.getTarget().getName().toLowerCase().matches("%cipherinit%") and
    result.asExpr() = this.getArgument(4) and
    type = KeyOperationSubtypeIO()
  }
}

/**
 * A call to EVP_Pkey_encrypt_init, EVP_Pkey_decrypt_init, or their 'ex' variants.
 */
class EvpPkeyEncryptDecryptInit extends OperationStep {
  EvpPkeyEncryptDecryptInit() {
    this.getTarget().getName() in [
        "EVP_PKEY_encrypt_init", "EVP_PKEY_encrypt_init_ex", "EVP_PKEY_decrypt_init",
        "EVP_PKEY_decrypt_init_ex"
      ]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = OsslParamIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

class EvpCipherInitSKeyCall extends EvpEX2Initializer {
  EvpCipherInitSKeyCall() { this.getTarget().getName() = "EVP_CipherInit_SKEY" }

  override DataFlow::Node getInput(IOType type) {
    result = super.getInput(type)
    or
    result.asExpr() = this.getArgument(5) and
    type = KeyOperationSubtypeIO()
  }
}

//EVP_PKEY_encrypt_init
/**
 * A Call to EVP_Cipher/Encrypt/DecryptUpdate.
 * https://docs.openssl.org/3.2/man3/EVP_CipherUpdate
 */
class EvpCipherUpdateCall extends OperationStep {
  EvpCipherUpdateCall() {
    this.getTarget().getName() in ["EVP_EncryptUpdate", "EVP_DecryptUpdate", "EVP_CipherUpdate"]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(1) and type = CiphertextIO()
    or
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = UpdateStep() }
}

/**
 * see: https://docs.openssl.org/master/man3/EVP_EncryptInit/#synopsis
 * Base configuration for all EVP cipher operations.
 */
abstract class EvpCipherOperationFinalStep extends OperationStep {
  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * A Call to EVP_Cipher.
 */
class EvpCipherCall extends EvpCipherOperationFinalStep {
  EvpCipherCall() { this.getTarget().getName() = "EVP_Cipher" }

  override DataFlow::Node getInput(IOType type) {
    super.getInput(type) = result
    or
    result.asExpr() = this.getArgument(2) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    super.getInput(type) = result
    or
    result.asExpr() = this.getArgument(1) and type = CiphertextIO()
  }
}

/**
 * A Call to an EVP Cipher/Encrypt/Decrypt final operation.
 */
class EvpCipherFinalCall extends EvpCipherOperationFinalStep {
  EvpCipherFinalCall() {
    this.getTarget().getName() in [
        "EVP_EncryptFinal_ex", "EVP_DecryptFinal_ex", "EVP_CipherFinal_ex", "EVP_EncryptFinal",
        "EVP_DecryptFinal", "EVP_CipherFinal"
      ]
  }

  override DataFlow::Node getOutput(IOType type) {
    super.getInput(type) = result
    or
    result.asDefiningArgument() = this.getArgument(1) and
    type = CiphertextIO()
    // TODO: could indicate text lengths here, as well
  }
}

/**
 * A call to a PKEY_encrypt or PKEY_decrypt operation.
 * https://docs.openssl.org/3.2/man3/EVP_PKEY_decrypt/
 * https://docs.openssl.org/3.2/man3/EVP_PKEY_encrypt
 */
class EvpPKeyCipherOperation extends EvpCipherOperationFinalStep {
  EvpPKeyCipherOperation() {
    this.getTarget().getName() in ["EVP_PKEY_encrypt", "EVP_PKEY_decrypt"]
  }

  override DataFlow::Node getInput(IOType type) {
    super.getInput(type) = result
    or
    result.asExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    super.getInput(type) = result
    or
    result.asExpr() = this.getArgument(1) and type = CiphertextIO()
    // TODO: could indicate text lengths here, as well
  }
}

/**
 * An EVP cipher operation instance.
 * Any operation step that is a final operation step for EVP cipher operation steps.
 */
class EvpCipherOperationInstance extends Crypto::KeyOperationInstance instanceof EvpCipherOperationFinalStep
{
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    super.getPrimaryAlgorithmValueConsumer() = result
  }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    result instanceof Crypto::TEncryptMode and
    super.getTarget().getName().toLowerCase().matches("%encrypt%")
    or
    result instanceof Crypto::TDecryptMode and
    super.getTarget().getName().toLowerCase().matches("%decrypt%")
    or
    super.getTarget().getName().toLowerCase().matches("%cipher%") and
    resolveKeyOperationSubTypeOperationStep(super
          .getDominatingInitializersToStep(KeyOperationSubtypeIO())) = result
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    super.getDominatingInitializersToStep(IVorNonceIO()).getInput(IVorNonceIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    super.getDominatingInitializersToStep(KeyIO()).getInput(KeyIO()) = result
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    super.getOutputStepFlowingToStep(CiphertextIO()).getOutput(CiphertextIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    super.getDominatingInitializersToStep(PlaintextIO()).getInput(PlaintextIO()) = result
  }
}
