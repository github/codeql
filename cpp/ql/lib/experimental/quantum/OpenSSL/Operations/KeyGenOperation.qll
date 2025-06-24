private import experimental.quantum.Language
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

/**
 * A call to EC_KEY_generate_key, which is used to generate an EC key pair.
 * Note: this is an operation, though the input parameter is a "EC_KEY*".
 * EC_KEY is really an empty context for a key that hasn't been generated, hence
 * we consider this an operation generating a key and not accepting a key input.
 */
class ECKeyGen extends OperationStep instanceof Call {
  //, Crypto::KeyGenerationOperationInstance {
  ECKeyGen() { this.(Call).getTarget().getName() = "EC_KEY_generate_key" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.(Call).getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) { result.asExpr() = this and type = KeyIO() }

  override OperationStepType getStepType() { result = ContextCreationStep() }
}

/**
 * A call to EVP_PKEY_keygen_init or EVP_PKEY_paramgen_init.
 */
class EvpKeyGenInitialize extends OperationStep {
  EvpKeyGenInitialize() {
    this.getTarget().getName() in [
        "EVP_PKEY_keygen_init",
        "EVP_PKEY_paramgen_init"
      ]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

abstract class KeyGenFinalOperationStep extends OperationStep {
  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * A call to `EVP_PKEY_Q_keygen`
 */
class EvpPKeyQKeyGen extends KeyGenFinalOperationStep instanceof Call {
  EvpPKeyQKeyGen() { this.getTarget().getName() = "EVP_PKEY_Q_keygen" }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this and type = KeyIO()
  }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    // When arg 3 is a derived type, it is a curve name, otherwise it is a key size for RSA if provided
    // and arg 2 is the algorithm type
    this.getArgument(3).getType().getUnderlyingType() instanceof DerivedType and
    result.asExpr() = this.getArgument(3) and
    type = PrimaryAlgorithmIO()
    or
    not this.getArgument(3).getType().getUnderlyingType() instanceof DerivedType and
    result.asExpr() = this.getArgument(2) and
    type = PrimaryAlgorithmIO()
    or
    not this.getArgument(3).getType().getUnderlyingType() instanceof DerivedType and
    result.asExpr() = this.getArgument(3) and
    type = KeySizeIO()
  }
}

/**
 * A call to `EVP_RSA_gen`
 */
class EvpRsaGen extends KeyGenFinalOperationStep instanceof Call {
  EvpRsaGen() { this.getTarget().getName() = "EVP_RSA_gen" }

  override DataFlow::Node getOutput(IOType type) { result.asExpr() = this and type = KeyIO() }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = KeySizeIO()
  }
}

/**
 * A call to RSA_generate_key
 */
class RsaGenerateKey extends KeyGenFinalOperationStep instanceof Call {
  RsaGenerateKey() { this.getTarget().getName() = "RSA_generate_key" }

  override DataFlow::Node getOutput(IOType type) { result.asExpr() = this and type = KeyIO() }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = KeySizeIO()
  }
}

/**
 * A call to RSA_generate_key_ex
 */
class RsaGenerateKeyEx extends KeyGenFinalOperationStep instanceof Call {
  RsaGenerateKeyEx() { this.getTarget().getName() = "RSA_generate_key_ex" }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = KeyIO()
  }

  override DataFlow::Node getInput(IOType type) {
    // arg 0 comes in as a blank RSA key, which we consider a context,
    // on output it is considered a key
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }
}

/**
 * A call to `EVP_PKEY_generate` or `EVP_PKEY_keygen`.
 */
class EvpPkeyGen extends KeyGenFinalOperationStep instanceof Call {
  EvpPkeyGen() { this.getTarget().getName() in ["EVP_PKEY_generate", "EVP_PKEY_keygen"] }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(1) and type = KeyIO()
    or
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }
}

/**
 * A call to `EVP_PKEY_new_mac_key` that creates a new generic MAC key.
 * - EVP_PKEY *EVP_PKEY_new_mac_key(int type, ENGINE *e, const unsigned char *key, int keylen);
 */
class EvpNewMacKey extends KeyGenFinalOperationStep {
  EvpNewMacKey() { this.getTarget().getName() = "EVP_PKEY_new_mac_key" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    // the raw key that is configured into the output key
    result.asExpr() = this.getArgument(2) and type = KeyIO()
    or
    result.asExpr() = this.getArgument(3) and type = KeySizeIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this and type = KeyIO()
    or
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }
}

/// TODO: https://docs.openssl.org/3.0/man3/EVP_PKEY_new/#synopsis
/**
 * An `KeyGenerationOperationInstance` for the for all key gen final operation steps.
 */
class KeyGenOperationInstance extends Crypto::KeyGenerationOperationInstance instanceof KeyGenFinalOperationStep
{
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    super.getPrimaryAlgorithmValueConsumer() = result
  }

  override Crypto::KeyArtifactType getOutputKeyType() { result = Crypto::TAsymmetricKeyType() }

  override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() {
    exists(OperationStep s |
      s.flowsToOperationStep(this) and
      result = s.getOutput(KeyIO())
    )
  }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    super.getDominatingInitializersToStep(KeySizeIO()).getInput(KeySizeIO()) = result
  }

  override int getKeySizeFixed() {
    none()
    // TODO: marked as none as the operation itself has no key size, it
    // comes from the algorithm source, but note we could grab the
    // algorithm source and get the key size (see below).
    // We may need to reconsider what is the best approach here.
    // result =
    //   this.getAnAlgorithmValueConsumer()
    //       .getAKnownAlgorithmSource()
    //       .(Crypto::EllipticCurveInstance)
    //       .getKeySize()
  }

  override Crypto::ConsumerInputDataFlowNode getRawKeyValueConsumer() {
    super.getDominatingInitializersToStep(KeyIO()).getInput(KeyIO()) = result
  }
}
