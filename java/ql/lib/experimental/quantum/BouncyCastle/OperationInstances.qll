import java

module Params {
  import FlowAnalysis
  import AlgorithmInstances

  /**
   * A model of the `Parameters` class in Bouncy Castle.
   */
  class Parameters extends Class {
    Parameters() {
      // Matches `org.bouncycastle.crypto.params`, `org.bouncycastle.asn1.x9`, etc.
      this.getPackage().getName().matches("org.bouncycastle.%") and
      this.getName().matches(["%Parameter", "%Parameters", "%ParameterSpec", "ParametersWith%"])
    }
  }

  class Curve extends Class {
    Curve() {
      this.getPackage().getName() = "org.bouncycastle.math.ec" and
      this.getName().matches("ECCurve")
    }
  }

  class KeyParameters extends Parameters {
    KeyParameters() {
      this.getPackage().getName() =
        ["org.bouncycastle.crypto.params", "org.bouncycastle.pqc.crypto.lms"] and
      this.getName().matches(["%KeyParameter", "%KeyParameters"])
    }
  }

  /**
   * A call that returns a BouncyCastle parameters object. This type is used
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

    // Can be overridden by subclasses which take a key argument.
    Expr getKeyArg() { none() }

    // Can be overridden by subclasses which take a nonce argument.
    Expr getNonceArg() { none() }

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

    Crypto::ConsumerInputDataFlowNode getKeyConsumer() { result.asExpr() = this.getKeyArg() }

    Crypto::ConsumerInputDataFlowNode getNonceConsumer() { result.asExpr() = this.getNonceArg() }

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
   * The named elliptic curve passed to `X9ECParameters.getCurve()`.
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
   * The named elliptic curve passed to `ECNamedCurveTable.getParameterSpec()`.
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

  /**
   * An `AEADParameters` instantiation.
   *
   * This type is used to model data flow from a nonce to a cipher operation.
   */
  class AeadParametersInstantiation extends ParametersInstantiation {
    AeadParametersInstantiation() {
      this.(ConstructorCall).getConstructedType().getName() = "AEADParameters"
    }

    override Expr getNonceArg() { result = this.(ConstructorCall).getArgument(2) }
  }

  class ParametersWithIvInstantiation extends ParametersInstantiation {
    ParametersWithIvInstantiation() {
      this.(ConstructorCall).getConstructedType().getName() = "ParametersWithIV"
    }

    override Expr getNonceArg() { result = this.(ConstructorCall).getArgument(1) }
  }

  /**
   * A `KeyParameter` instantiation.
   *
   * This type is used to model data flow from a key to a cipher operation.
   */
  class KeyParameterInstantiation extends ParametersInstantiation {
    KeyParameterInstantiation() {
      this.(ConstructorCall).getConstructedType().getName() = "KeyParameter"
    }

    override Expr getKeyArg() { result = this.(ConstructorCall).getArgument(0) }
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
  class Signer extends Class {
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

  /**
   * This class represents signers with a one shot API (where the entire message
   * is passed to either `generateSignature()` or `verifySignature`.).
   */
  class OneShotSigner extends Signer {
    OneShotSigner() { this.getName().matches(["DSASigner", "ECDSA%", "LMS%", "HSS%"]) }

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

  // Instantiate the flow analysis module for the `Signer` class.
  private module SignerFlow = NewToInitToUseFlow<SignerNewCall, SignerInitCall, SignerUseCall>;

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
  class KeyGenerator extends Class {
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
   * A call to either `generateKey()` and `generateKeyPair()`.
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
    NewToInitToUseFlow<KeyGeneratorNewCall, KeyGeneratorInitCall, KeyGeneratorUseCall>;

  module ParametersFlow =
    ParametersToInitFlow<Params::ParametersInstantiation, KeyGeneratorInitCall>;

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

module Modes {
  import FlowAnalysis

  abstract class BlockCipherMode extends Class {
    abstract MethodCall getAnInitCall();

    abstract MethodCall getAUseCall();
  }

  /**
   * An unpadded block cipher mode like CTR or GCM.
   */
  class UnpaddedBlockCipherMode extends BlockCipherMode {
    UnpaddedBlockCipherMode() {
      this.getPackage().getName() = "org.bouncycastle.crypto.modes" and
      this.getName().matches("%BlockCipher")
    }

    override MethodCall getAnInitCall() { result = this.getAMethodCall("init") }

    override MethodCall getAUseCall() {
      result =
        this.getAMethodCall([
            "processBlock", "processBlocks", "returnByte", "processBytes", "doFinal"
          ])
    }

    MethodCall getAMethodCall(string name) {
      result.getQualifier().getType() instanceof UnpaddedBlockCipherMode and
      result.getMethod().getName() = name
    }
  }

  /**
   * A block cipher padding mode, like PKCS7.
   */
  class PaddingMode extends Class {
    PaddingMode() {
      this.getPackage().getName() = "org.bouncycastle.crypto.paddings" and
      this.getName().matches("%Padding")
    }
  }

  /**
   * A block cipher mode that uses a padding scheme, like CBC.
   */
  class PaddedBlockCipherMode extends BlockCipherMode {
    PaddedBlockCipherMode() {
      this.getPackage().getName() = "org.bouncycastle.crypto.paddings" and
      this.getName() = "PaddedBufferedBlockCipher"
    }

    override MethodCall getAnInitCall() { result = this.getAMethodCall("init") }

    override MethodCall getAUseCall() {
      result =
        this.getAMethodCall([
            "processBlock", "processBlocks", "returnByte", "processBytes", "doFinal"
          ])
    }

    MethodCall getAMethodCall(string name) {
      result.getQualifier().getType() instanceof PaddedBlockCipherMode and
      result.getMethod().getName() = name
    }
  }

  class BlockCipher extends Class {
    BlockCipher() {
      this.getPackage().getName() = "org.bouncycastle.crypto.engines" and
      this.getName().matches("%Engine")
    }
  }

  /**
   * A block cipher mode instantiation.
   *
   * This class represents both unpadded block cipher mode instantiations (like
   * `GCMBlockCipher` and `CBCBlockCipher`), as well as padded block cipher mode
   * instantiations (like `PaddedBufferedBlockCipher`). Both can be used to
   * encrypt and decrypt data.
   */
  private class BlockCipherModeNewCall extends ClassInstanceExpr {
    BlockCipherModeNewCall() { this.getType() instanceof BlockCipherMode }

    Crypto::AlgorithmValueConsumer getBlockCipherConsumer() {
      result = this.getUnpaddedBlockCipherMode().getBlockCipherArg()
    }

    BlockCipherModeNewCall getUnpaddedBlockCipherMode() {
      this.getConstructedType() instanceof UnpaddedBlockCipherMode and
      result = this
      or
      this.getConstructedType() instanceof PaddedBlockCipherMode and
      result = BlockCipherModeToBlockCipherModeFlow::getUnpaddedModeFromPaddedMode(this, _, _)
    }

    Expr getBlockCipherArg() {
      exists(Expr arg |
        arg = this.getAnArgument() and
        arg.getType() instanceof Modes::BlockCipher and
        result = arg
      )
    }

    DataFlow::Node getParametersInput() { none() }

    DataFlow::Node getEllipticCurveInput() { none() }
  }

  /**
   * A call to a block cipher mode `init()` method.
   *
   * The type is instantiated by a constructor call and initialized by a call to
   * `init()` which takes a single `KeyGenerationParameters` argument.
   */
  private class BlockCipherModeInitCall extends MethodCall {
    BlockCipherModeInitCall() { this = any(BlockCipherMode mode).getAnInitCall() }

    // This is true if the mode is being initialized for encryption.
    Expr getEncryptingArg() { result = this.getArgument(0) }

    Crypto::KeyOperationSubtype getKeyOperationSubtype() {
      // The key operation sub-type is determined by the `encrypting` argument to `init()`.
      if BooleanLiteralToInitFlow::hasBooleanValue(this.getEncryptingArg(), _, _)
      then
        if BooleanLiteralToInitFlow::getBooleanValue(this.getEncryptingArg(), _, _) = true
        then result = Crypto::TEncryptMode()
        else result = Crypto::TDecryptMode()
      else result = Crypto::TUnknownKeyOperationMode()
    }

    Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

    // The `CipherParameters` argument used to configure the cipher.
    DataFlow::Node getParametersInput() { result.asExpr() = this.getArgument(1) }
  }

  /**
   * A `processX()`, `returnByte()` or `doFinal()` method call to encrypt or
   * decrypt data.
   */
  private class BlockCipherModeUseCall extends MethodCall {
    BlockCipherMode mode;

    BlockCipherModeUseCall() { this = mode.getAUseCall() }

    predicate isIntermediate() { not this.getCallee().getName() = "doFinal" }

    Expr getInput() { result = this.getArgument(0) }

    Expr getOutput() {
      this.getCallee().getName() = "processBlock" and
      result = this.getArgument(2) // The `out` byte array argument.
      or
      this.getCallee().getName() = "processBlocks" and
      result = this.getArgument(3) // The `out` byte array argument.
      or
      this.getCallee().getName() = "processBytes" and
      result = this.getArgument(3) // The `out` byte array argument.
      or
      this.getCallee().getName() = "returnByte" and
      result = this // The return value.
    }
  }

  module BlockCipherModeFlow =
    NewToInitToUseFlow<BlockCipherModeNewCall, BlockCipherModeInitCall, BlockCipherModeUseCall>;

  module ParametersFlow =
    ParametersToInitFlow<Params::ParametersInstantiation, BlockCipherModeInitCall>;

  /**
   * A block cipher mode operation is a call to a finalizing method (like
   * `doFinal()`) on the block cipher mode instance. The encryption algorithm and
   * padding mode are determined from the parameters passed to `init()`.
   */
  class BlockCipherModeOperationInstance extends Crypto::KeyOperationInstance instanceof BlockCipherModeUseCall
  {
    BlockCipherModeOperationInstance() { not this.isIntermediate() }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      // The class instantiation (returned by `getNewFromUse()`) represents the
      // block cipher *mode* algorithm instance. Here, we need to return the
      // block cipher algorithm instance which is resolved from the algorithm
      // mode using data flow (in `getBlockCipherAlgorithmConsumer()`).
      result = this.getNewCall().getBlockCipherConsumer()
    }

    override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
      // The key operation sub-type is determined by the `encrypting` argument to `init()`.
      exists(this.getInitCall()) and
      result = this.getInitCall().getKeyOperationSubtype()
      or
      not exists(this.getInitCall()) and
      result = Crypto::TUnknownKeyOperationMode()
    }

    BlockCipherModeNewCall getNewCall() { result = BlockCipherModeFlow::getNewFromUse(this, _, _) }

    BlockCipherModeInitCall getInitCall() {
      result = BlockCipherModeFlow::getInitFromUse(this, _, _)
    }

    BlockCipherModeUseCall getAUseCall() {
      result = BlockCipherModeFlow::getAnIntermediateUseFromFinalUse(this, _, _)
      or
      result = this
    }

    Params::ParametersInstantiation getParameters() {
      result = ParametersFlow::getParametersFromInit(this.getInitCall(), _, _)
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
      result.asExpr() = this.getAUseCall().getOutput()
    }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      result.asExpr() = this.getAUseCall().getInput()
    }

    override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
      result = this.getParameters().getKeyConsumer()
    }

    override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
      result = this.getParameters().getNonceConsumer()
    }
  }
}
