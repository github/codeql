import java

/**
 * Models for the signature algorithms defined by the `org.bouncycastle.crypto.signers` package.
 */
module Signers {
  import Language
  import BouncyCastle.FlowAnalysis
  import BouncyCastle.AlgorithmInstances

  /**
   * A model of the `Signer` class in Bouncy Castle.
   */
  class Signer extends RefType {
    Signer() {
      this.getPackage().getName() = "org.bouncycastle.crypto.signers" and
      this.getName().matches("%Signer")
    }

    MethodCall getAnInitCall() { result = this.getAMethodCall("init") }

    MethodCall getAUseCall() {
      result = this.getAMethodCall(["update", "generateSignature", "verifySignature"])
    }

    MethodCall getAMethodCall(string name) {
      result.getCallee().hasQualifiedName(this.getPackage().getName(), this.getName(), name)
    }
  }

  /**
   * BouncyCastle algorithms are instantiated by calling the constructor of the
   * corresponding class, which also represents the algorithm instance.
   */
  private class SignerNewCall = SignatureAlgorithmInstance;

  /**
   * The type is instantiated by a constructor call and initialized by a call to
   * `init()` which takes two arguments. The first argument is a flag indicating
   * whether the operation is signing data or verifying a signature, and the
   * second is the key to use.
   */
  private class SignerInitCall extends MethodCall {
    SignerInitCall() { this = any(Signer signer).getAnInitCall() }

    Expr getForSigningArg() { result = this.getArgument(0) }

    Expr getKeyArg() { result = this.getArgument(1) }

    // TODO: Support dataflow for the operation sub-type.
    Crypto::KeyOperationSubtype getKeyOperationSubtype() {
      if this.isOperationSubTypeKnown()
      then
        this.getForSigningArg().(BooleanLiteral).getBooleanValue() = true and
        result = Crypto::TSignMode()
        or
        this.getForSigningArg().(BooleanLiteral).getBooleanValue() = false and
        result = Crypto::TVerifyMode()
      else result = Crypto::TUnknownKeyOperationMode()
    }

    predicate isOperationSubTypeKnown() { this.getForSigningArg() instanceof BooleanLiteral }
  }

  /**
   * The `update()` method is used to pass message data to the signer, and the
   * `generateSignature()` or `verifySignature()` methods are used to produce or
   * verify the signature, respectively.
   */
  private class SignerUseCall extends MethodCall {
    SignerUseCall() { this = any(Signer signer).getAUseCall() }

    predicate isIntermediate() { this.getCallee().getName() = "update" }

    Expr getInput() { result = this.getArgument(0) }

    Expr getOutput() { result = this }
  }

  /**
   * Instantiate the flow analysis module for the `Signer` class.
   */
  private module FlowAnalysis =
    NewToInitToUseFlowAnalysis<SignerNewCall, SignerInitCall, SignerUseCall>;

  /**
   * A signing operation instance is a call to either `update()`, `generateSignature()`,
   * or `verifySignature()` on a `Signer` instance.
   */
  class SignatureOperationInstance extends Crypto::KeyOperationInstance instanceof SignerUseCall {
    SignatureOperationInstance() { not this.isIntermediate() }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      result = FlowAnalysis::getNewFromUse(this, _, _)
    }

    override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
      if FlowAnalysis::hasInit(this)
      then result = this.getInitCall().getKeyOperationSubtype()
      else result = Crypto::TUnknownKeyOperationMode()
    }

    override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
      result.asExpr() = this.getInitCall().getKeyArg()
    }

    override Crypto::ConsumerInputDataFlowNode getNonceConsumer() { none() }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      result.asExpr() = this.getAnUpdateCall().getInput()
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
      this.getKeyOperationSubtype() = Crypto::TSignMode() and
      result.asExpr() = super.getOutput()
    }

    SignerInitCall getInitCall() { result = FlowAnalysis::getInitFromUse(this, _, _) }

    SignerUseCall getAnUpdateCall() {
      result = FlowAnalysis::getAnIntermediateUseFromFinalUse(this, _, _)
    }
  }
}

/**
 * Models for the key generation algorithms defined by the `org.bouncycastle.crypto.generators` package.
 */
module Generators {
  import Language
  import BouncyCastle.FlowAnalysis
  import BouncyCastle.AlgorithmInstances

  /**
   * A model of the `KeyGenerator` and `KeyPairGenerator` classes in Bouncy Castle.
   */
  class KeyGenerator extends RefType {
    Crypto::KeyArtifactType type;

    KeyGenerator() {
      this.getPackage().getName() = "org.bouncycastle.crypto.generators" and
      (
        this.getName().matches("%KeyGenerator") and type instanceof Crypto::TSymmetricKeyType
        or
        this.getName().matches("%KeyPairGenerator") and type instanceof Crypto::TAsymmetricKeyType
      )
    }

    MethodCall getAnInitCall() { result = this.getAMethodCall("init") }

    MethodCall getAUseCall() { result = this.getAMethodCall(["generateKey", "generateKeyPair"]) }

    MethodCall getAMethodCall(string name) {
      result.getCallee().hasQualifiedName(this.getPackage().getName(), this.getName(), name)
    }

    Crypto::KeyArtifactType getKeyType() { result = type }
  }

  /**
   * This type is used to model data flow from a key pair to the private and
   * public components of the key pair.
   */
  class KeyPair extends RefType {
    KeyPair() {
      this.getPackage().getName() = "org.bouncycastle.crypto" and
      this.getName() = "%KeyPair" // `AsymmetricCipherKeyPair` or `EphemeralKeyPair`
    }

    MethodCall getPublicKeyCall() { result = this.getAMethodCall("getPublic") }

    MethodCall getPrivateKeyCall() { result = this.getAMethodCall("getPrivate") }

    MethodCall getAMethodCall(string name) {
      result.getCallee().hasQualifiedName("org.bouncycastle.crypto", this.getName(), name)
    }
  }

  /**
   * BouncyCastle algorithms are instantiated by calling the constructor of the
   * corresponding class, which also represents the algorithm instance.
   */
  private class KeyGeneratorNewCall = KeyGenerationAlgorithmInstance;

  /**
   * The type is instantiated by a constructor call and initialized by a call to
   * `init()` which takes a single `KeyGenerationParameters` argument.
   */
  private class KeyGeneratorInitCall extends MethodCall {
    KeyGenerator gen;

    KeyGeneratorInitCall() { this = gen.getAnInitCall() }

    // TODO: We may need to model this using the `parameters` argument passed to
    // the `init()` method.
    Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }
  }

  /**
   * The `generateKey()` and `generateKeyPair()` methods are used to generate
   * the resulting key, depending on the type of the generator.
   */
  private class KeyGeneratorUseCall extends MethodCall {
    KeyGenerator gen;

    KeyGeneratorUseCall() { this = gen.getAUseCall() }

    // Since key generators don't have `update()` methods, this is always false.
    predicate isIntermediate() { none() }

    Crypto::KeyArtifactType getKeyType() { result = gen.getKeyType() }

    Expr getOutput() { result = this }
  }

  private module KeyGeneratorFlow =
    NewToInitToUseFlowAnalysis<KeyGeneratorNewCall, KeyGeneratorInitCall, KeyGeneratorUseCall>;

  /**
   * A key generation operation instance is a call to `generateKey()` or
   * `generateKeyPair()` on a key generator defined under
   * `org.bouncycastle.crypto.generators`.
   */
  class KeyGenerationOperationInstance extends Crypto::KeyGenerationOperationInstance instanceof KeyGeneratorUseCall
  {
    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      result = KeyGeneratorFlow::getNewFromUse(this, _, _)
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() {
      result.asExpr() = super.getOutput()
    }

    override Crypto::KeyArtifactType getOutputKeyType() { result = super.getKeyType() }

    override int getKeySizeFixed() {
      result = KeyGeneratorFlow::getNewFromUse(this, _, _).getKeySizeFixed()
    }

    override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
      result = KeyGeneratorFlow::getInitFromUse(this, _, _).getKeySizeConsumer()
    }
  }
}

/**
 * Models for cryptographic parameters defined by the `org.bouncycastle.crypto.params` package.
 */
module Parameters {
  class KeyGenerationParameters extends RefType {
    KeyGenerationParameters() {
      this.getPackage().getName() = "org.bouncycastle.crypto.params" and
      this.getName().matches("%KeyGenerationParameters")
    }
  }
}
