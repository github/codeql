import java

module Params {
  import FlowAnalysis
  import AlgorithmInstances

  /**
   * A model of the `Parameters` class in Bouncy Castle.
   */
  class Parameters extends RefType {
    Parameters() {
      // Matches `org.bouncycastle.crypto.params`, `org.bouncycastle.asn1.x9`, etc.
      this.getPackage().getName().matches("org.bouncycastle.%") and
      this.getName().matches(["%Parameters", "%ParameterSpec"])
    }
  }

  class Curve extends RefType {
    Curve() {
      this.getPackage().getName() = "org.bouncycastle.math.ec" and
      this.getName().matches("ECCurve")
    }
  }

  class KeyParameters extends Parameters {
    KeyParameters() {
      this.getPackage().getName() =
        ["org.bouncycastle.crypto.params", "org.bouncycastle.pqc.crypto.lms"] and
      this.getName().matches("%KeyParameters")
    }
  }

  /**
   * Any call that returns a BouncyCastle parameters object. This type is used
   * to model data flow to resolve algorithm instances like elliptic curves.
   *
   * Examples:
   * ```
   * curveParams = SECNamedCurves.getByName(...);
   * domainParams = new ECDomainParameters(...);
   * ```
   */
  class ParametersInstantiation extends Call {
    ParametersInstantiation() {
      // Class instantiations
      this.(ConstructorCall).getConstructedType() instanceof Parameters
      or
      // (Static) factory methods
      this.(MethodCall)
          .getCallee()
          .getDeclaringType()
          .getPackage()
          .getName()
          .matches("org.bouncycastle.%") and
      this.(MethodCall).getType() instanceof Parameters
    }

    // Can be overridden by subclasses which take a key size argument.
    Expr getKeySizeArg() { none() }

    // Can be overridden by subclasses which take an algorithm argument.
    Expr getAlgorithmArg() { none() }

    Expr getAParametersArg() {
      result = this.getAnArgument() and
      result.getType() instanceof Parameters
    }

    Expr getAnEllipticCurveArg() {
      result = this.getAnArgument() and
      result.getType() instanceof Curve
    }

    Crypto::ConsumerInputDataFlowNode getAKeySizeConsumer() {
      result.asExpr() = this.getKeySizeArg()
    }

    Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      result.getInputNode().asExpr() = this.getAlgorithmArg()
    }

    DataFlow::Node getParametersInput() { result.asExpr() = this.getAParametersArg() }

    DataFlow::Node getEllipticCurveInput() { result.asExpr() = this.getAnEllipticCurveArg() }
  }

  /**
   * Models the named elliptic curve passed to `X9ECParameters.getCurve()`.
   */
  class X9ECParametersInstantiation extends ParametersInstantiation {
    X9ECParametersInstantiation() { this.(Expr).getType().getName() = "X9ECParameters" }

    override Expr getAlgorithmArg() {
      this.(MethodCall).getQualifier().getType().getName() = "SECNamedCurves" and
      this.(MethodCall).getCallee().getName() = "getByName" and
      result = this.getArgument(0)
    }
  }

  /**
   * Models the named elliptic curve passed to `ECNamedCurveTable.getParameterSpec()`.
   */
  class ECNamedCurveParameterSpecInstantiation extends ParametersInstantiation {
    ECNamedCurveParameterSpecInstantiation() {
      this.(Expr).getType().getName() = "ECNamedCurveParameterSpec"
    }

    override Expr getAlgorithmArg() {
      this.(MethodCall).getQualifier().getType().getName() = "ECNamedCurveTable" and
      this.(MethodCall).getCallee().getName() = "getParameterSpec" and
      result = this.getArgument(0)
    }
  }
}

/**
 * Models for the signature algorithms defined by the `org.bouncycastle.crypto.signers` package.
 */
module Signers {
  import FlowAnalysis
  import AlgorithmInstances

  /**
   * A model of the `Signer` class in Bouncy Castle.
   *
   * This class represents a BouncyCastle signer with a streaming API. For signers
   * with a one-shot API, see `OneShotSigner` below.
   */
  class Signer extends RefType {
    Signer() {
      this.getPackage().getName() =
        ["org.bouncycastle.crypto.signers", "org.bouncycastle.pqc.crypto.lms"] and
      this.getName().matches("%Signer")
    }

    MethodCall getAnInitCall() { result = this.getAMethodCall("init") }

    MethodCall getAUseCall() {
      result = this.getAMethodCall(["update", "generateSignature", "verifySignature"])
    }

    MethodCall getAMethodCall(string name) {
      result.getCallee().hasQualifiedName(this.getPackage().getName(), this.getName(), name)
    }

    // Overridden by subclasses to provide the message argument.
    Expr getMessageArg(MethodCall call) {
      call.getCallee().getName() = "update" and
      result = call.getArgument(0)
    }

    // Overridden by subclasses to provide the signature argument.
    Expr getSignatureArg(MethodCall call) {
      call.getCallee().getName() = "verifySignature" and
      result = call.getArgument(0)
    }

    // Overridden by subclasses to provide the signature output.
    Expr getSignatureOutput(MethodCall call) {
      call.getCallee().getName() = "generateSignature" and
      result = call
    }
  }

  class OneShotSigner extends Signer {
    OneShotSigner() { this.getName().matches(["ECDSA%", "LMS%"]) }

    override Expr getMessageArg(MethodCall call) {
      // For ECDSA and LMS, the message is passed directly to `generateSignature()`.
      call.getCallee().getName().matches(["generateSignature", "verifySignature"]) and
      result = call.getArgument(0)
    }

    override Expr getSignatureArg(MethodCall call) {
      // For ECDSA, r and s are passed to `verifySignature()` as separate arguments.
      // For LMS, the signature is passed as a single argument in position 1.
      call.getCallee().getName() = "verifySignature" and
      result = call.getArgument([1, 2])
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

    Expr getKeyArg() {
      this.getParametersArg().getType() instanceof Params::KeyParameters and
      result = this.getParametersArg()
    }

    // The second argument is used to provide parameters (like the key) to the signer.
    Expr getParametersArg() { result = this.getArgument(1) }

    DataFlow::Node getParametersInput() { result.asExpr() = this.getParametersArg() }
  }

  /**
   * The `update()` method is used to pass message data to the signer, and the
   * `generateSignature()` or `verifySignature()` methods are used to produce or
   * verify the signature, respectively.
   */
  private class SignerUseCall extends MethodCall {
    Signer signer;

    SignerUseCall() { this = signer.getAUseCall() }

    predicate isIntermediate() { this.getCallee().getName() = "update" }

    Expr getMessageInput() { result = signer.getMessageArg(this) }

    Expr getSignatureInput() { result = signer.getSignatureArg(this) }

    Expr getSignatureOutput() { result = signer.getSignatureOutput(this) }
  }

  /**
   * Instantiate the flow analysis module for the `Signer` class.
   */
  private module SignerFlow =
    NewToInitToUseFlowAnalysis<SignerNewCall, SignerInitCall, SignerUseCall>;

  /**
   * A signing operation instance is a call to either `update()`, `generateSignature()`,
   * or `verifySignature()` on a `Signer` instance.
   */
  class SignatureOperationInstance extends Crypto::SignatureOperationInstance instanceof SignerUseCall
  {
    SignatureOperationInstance() { not this.isIntermediate() }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      result = SignerFlow::getNewFromUse(this, _, _)
    }

    override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
      // This is less expensive and more robust than resolving the subtype using
      // dataflow from the `forSigning` argument to `init()`.
      if super.getMethod().getName() = "generateSignature"
      then result = Crypto::TSignMode()
      else
        if super.getMethod().getName() = "verifySignature"
        then result = Crypto::TVerifyMode()
        else result = Crypto::TUnknownKeyOperationMode()
    }

    override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
      result.asExpr() = this.getInitCall().getKeyArg()
    }

    override Crypto::ConsumerInputDataFlowNode getNonceConsumer() { none() }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      // Inputs to signers with streaming APIs
      result.asExpr() = this.getAnUpdateCall().getMessageInput()
      or
      // Inputs to signers with one shot APIs
      result.asExpr() = super.getMessageInput()
    }

    override Crypto::ConsumerInputDataFlowNode getSignatureConsumer() {
      result.asExpr() = super.getSignatureInput()
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
      // Signature output
      result.asExpr() = super.getSignatureOutput()
    }

    SignerInitCall getInitCall() { result = SignerFlow::getInitFromUse(this, _, _) }

    SignerUseCall getAnUpdateCall() {
      result = SignerFlow::getAnIntermediateUseFromFinalUse(this, _, _)
    }
  }
}

/**
 * Models for the key generation algorithms defined by the `org.bouncycastle.crypto.generators` package.
 */
module Generators {
  import FlowAnalysis
  import AlgorithmInstances

  /**
   * A model of the `KeyGenerator` and `KeyPairGenerator` classes in Bouncy Castle.
   */
  class KeyGenerator extends RefType {
    Crypto::KeyArtifactType type;

    KeyGenerator() {
      this.getPackage().getName() =
        ["org.bouncycastle.crypto.generators", "org.bouncycastle.pqc.crypto.lms"] and
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

    Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

    // The `KeyGenerationParameters` argument used to configure the key generator.
    DataFlow::Node getParametersInput() { result.asExpr() = this.getArgument(0) }
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

  module KeyGeneratorFlow =
    NewToInitToUseFlowAnalysis<KeyGeneratorNewCall, KeyGeneratorInitCall, KeyGeneratorUseCall>;

  module ParametersFlow =
    ParametersToInitFlowAnalysis<Params::ParametersInstantiation, KeyGeneratorInitCall>;

  /**
   * A key generation operation instance is a call to `generateKey()` or
   * `generateKeyPair()` on a key generator defined under
   * `org.bouncycastle.crypto.generators`.
   */
  class KeyGenerationOperationInstance extends Crypto::KeyGenerationOperationInstance instanceof KeyGeneratorUseCall
  {
    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      // The algorithm is implicitly defined by the key generator type
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

    Params::ParametersInstantiation getParameters() {
      exists(KeyGeneratorInitCall init |
        init = KeyGeneratorFlow::getInitFromUse(this, _, _) and
        result = ParametersFlow::getParametersFromInit(init, _, _)
      )
    }
  }
}

module Modes { }
