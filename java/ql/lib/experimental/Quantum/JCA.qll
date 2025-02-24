import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.controlflow.Dominance

module JCAModel {
  import Language

  // TODO: Verify that the PBEWith% case works correctly
  bindingset[algo]
  predicate cipher_names(string algo) {
    algo.toUpperCase()
        .matches([
            "AES", "AESWrap", "AESWrapPad", "ARCFOUR", "Blowfish", "ChaCha20", "ChaCha20-Poly1305",
            "DES", "DESede", "DESedeWrap", "ECIES", "PBEWith%", "RC2", "RC4", "RC5", "RSA"
          ].toUpperCase())
  }

  // TODO: Verify that the CFB% case works correctly
  bindingset[mode]
  predicate cipher_modes(string mode) {
    mode.toUpperCase()
        .matches([
            "NONE", "CBC", "CCM", "CFB", "CFB%", "CTR", "CTS", "ECB", "GCM", "KW", "KWP", "OFB",
            "OFB%", "PCBC"
          ].toUpperCase())
  }

  // TODO: Verify that the OAEPWith% case works correctly
  bindingset[padding]
  predicate cipher_padding(string padding) {
    padding
        .toUpperCase()
        .matches([
            "NoPadding", "ISO10126Padding", "OAEPPadding", "OAEPWith%", "PKCS1Padding",
            "PKCS5Padding", "SSL3Padding"
          ].toUpperCase())
  }

  /**
   * A `StringLiteral` in the `"ALG/MODE/PADDING"` or `"ALG"` format
   */
  class CipherStringLiteral extends StringLiteral {
    CipherStringLiteral() { cipher_names(this.getValue().splitAt("/")) }

    string getAlgorithmName() { result = this.getValue().splitAt("/", 0) }

    string getMode() { result = this.getValue().splitAt("/", 1) }

    string getPadding() { result = this.getValue().splitAt("/", 2) }
  }

  class CipherGetInstanceCall extends Call {
    CipherGetInstanceCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "Cipher", "getInstance")
    }

    Expr getAlgorithmArg() { result = this.getArgument(0) }

    Expr getProviderArg() { result = this.getArgument(1) }
  }

  private class JCACipherOperationCall extends Call {
    JCACipherOperationCall() {
      exists(string s | s in ["doFinal", "wrap", "unwrap"] |
        this.getCallee().hasQualifiedName("javax.crypto", "Cipher", s)
      )
    }

    DataFlow::Node getInputData() { result.asExpr() = this.getArgument(0) }
  }

  /**
   * Data-flow configuration modelling flow from a cipher string literal to a `CipherGetInstanceCall` argument.
   */
  private module AlgorithmStringToFetchConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CipherStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      exists(CipherGetInstanceCall call | sink.asExpr() = call.getAlgorithmArg())
    }
  }

  module AlgorithmStringToFetchFlow = DataFlow::Global<AlgorithmStringToFetchConfig>;

  /**
   * The cipher algorithm argument to a `CipherGetInstanceCall`.
   *
   * For example, in `Cipher.getInstance(algorithm)`, this class represents `algorithm`.
   */
  class CipherGetInstanceAlgorithmArg extends Crypto::CipherAlgorithmInstance,
    Crypto::BlockCipherModeOfOperationAlgorithmInstance, Crypto::PaddingAlgorithmInstance instanceof Expr
  {
    CipherGetInstanceCall call;

    CipherGetInstanceAlgorithmArg() { this = call.getAlgorithmArg() }

    /**
     * Returns the `StringLiteral` from which this argument is derived, if known.
     */
    CipherStringLiteral getOrigin() {
      AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(result),
        DataFlow::exprNode(this.(Expr).getAChildExpr*()))
    }

    CipherGetInstanceCall getCall() { result = call }
  }

  /**
   * An access to the `javax.crypto.Cipher` class.
   */
  private class CipherAccess extends TypeAccess {
    CipherAccess() { this.getType().(Class).hasQualifiedName("javax.crypto", "Cipher") }
  }

  /**
   * An access to a cipher mode field of the `javax.crypto.Cipher` class,
   * specifically `ENCRYPT_MODE`, `DECRYPT_MODE`, `WRAP_MODE`, or `UNWRAP_MODE`.
   */
  private class JavaxCryptoCipherOperationModeAccess extends FieldAccess {
    JavaxCryptoCipherOperationModeAccess() {
      this.getQualifier() instanceof CipherAccess and
      this.getField().getName().toUpperCase() in [
          "ENCRYPT_MODE", "DECRYPT_MODE", "WRAP_MODE", "UNWRAP_MODE"
        ]
    }
  }

  class CipherUpdateCall extends MethodCall {
    CipherUpdateCall() { this.getMethod().hasQualifiedName("javax.crypto", "Cipher", "update") }

    DataFlow::Node getInputData() { result.asExpr() = this.getArgument(0) }
  }

  private newtype TCipherModeFlowState =
    TUninitializedCipherModeFlowState() or
    TInitializedCipherModeFlowState(CipherInitCall call) or
    TUsedCipherModeFlowState(CipherInitCall init, CipherUpdateCall update)

  abstract private class CipherModeFlowState extends TCipherModeFlowState {
    string toString() {
      this = TUninitializedCipherModeFlowState() and result = "uninitialized"
      or
      this = TInitializedCipherModeFlowState(_) and result = "initialized"
    }

    abstract Crypto::CipherOperationSubtype getCipherOperationMode();
  }

  private class UninitializedCipherModeFlowState extends CipherModeFlowState,
    TUninitializedCipherModeFlowState
  {
    override Crypto::CipherOperationSubtype getCipherOperationMode() {
      result instanceof Crypto::UnknownCipherOperationMode
    }
  }

  private class InitializedCipherModeFlowState extends CipherModeFlowState,
    TInitializedCipherModeFlowState
  {
    CipherInitCall call;
    DataFlow::Node node1;
    DataFlow::Node node2;
    Crypto::CipherOperationSubtype mode;

    InitializedCipherModeFlowState() {
      this = TInitializedCipherModeFlowState(call) and
      DataFlow::localFlowStep(node1, node2) and
      node2.asExpr() = call.getQualifier() and
      // TODO: does this make this predicate inefficient as it binds with anything?
      not node1.asExpr() = call.getQualifier() and
      mode = call.getCipherOperationModeType()
    }

    CipherInitCall getInitCall() { result = call }

    DataFlow::Node getFstNode() { result = node1 }

    /**
     * Returns the node *to* which the state-changing step occurs
     */
    DataFlow::Node getSndNode() { result = node2 }

    override Crypto::CipherOperationSubtype getCipherOperationMode() { result = mode }
  }

  /**
   * Trace from cipher initialization to a cryptographic operation,
   * specifically `Cipher.doFinal()`, `Cipher.wrap()`, or `Cipher.unwrap()`.
   *
   * TODO: handle `Cipher.update()`
   */
  private module CipherGetInstanceToCipherOperationConfig implements DataFlow::StateConfigSig {
    class FlowState = TCipherModeFlowState;

    predicate isSource(DataFlow::Node src, FlowState state) {
      state instanceof UninitializedCipherModeFlowState and
      src.asExpr() instanceof CipherGetInstanceCall
    }

    predicate isSink(DataFlow::Node sink, FlowState state) { none() }

    predicate isSink(DataFlow::Node sink) {
      exists(JCACipherOperationCall c | c.getQualifier() = sink.asExpr())
    }

    predicate isAdditionalFlowStep(
      DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
    ) {
      node1 = state2.(InitializedCipherModeFlowState).getFstNode() and
      node2 = state2.(InitializedCipherModeFlowState).getSndNode()
    }

    predicate isBarrier(DataFlow::Node node, FlowState state) {
      exists(CipherInitCall call | node.asExpr() = call.getQualifier() |
        state instanceof UninitializedCipherModeFlowState
        or
        state.(InitializedCipherModeFlowState).getInitCall() != call
      )
    }
  }

  module CipherGetInstanceToCipherOperationFlow =
    DataFlow::GlobalWithState<CipherGetInstanceToCipherOperationConfig>;

  class CipherOperationInstance extends Crypto::CipherOperationInstance instanceof Call {
    Crypto::CipherOperationSubtype mode;
    Crypto::CipherAlgorithmInstance algorithm;
    CipherGetInstanceToCipherOperationFlow::PathNode sink;
    JCACipherOperationCall doFinalize;

    CipherOperationInstance() {
      exists(
        CipherGetInstanceToCipherOperationFlow::PathNode src, CipherGetInstanceCall getCipher,
        CipherGetInstanceAlgorithmArg arg
      |
        CipherGetInstanceToCipherOperationFlow::flowPath(src, sink) and
        src.getNode().asExpr() = getCipher and
        sink.getNode().asExpr() = doFinalize.getQualifier() and
        sink.getState().(CipherModeFlowState).getCipherOperationMode() = mode and
        this = doFinalize and
        arg.getCall() = getCipher and
        algorithm = arg
      )
    }

    override Crypto::CipherAlgorithmInstance getAlgorithm() { result = algorithm }

    override Crypto::CipherOperationSubtype getCipherOperationSubtype() { result = mode }

    override Crypto::NonceArtifactInstance getNonce() {
      NonceArtifactToCipherInitCallFlow::flow(result.asOutputData(),
        DataFlow::exprNode(sink.getState()
              .(InitializedCipherModeFlowState)
              .getInitCall()
              .getNonceArg()))
    }

    override DataFlow::Node getInputData() { result = doFinalize.getInputData() }
  }

  /**
   * A block cipher mode of operation, where the mode is specified in the ALG or ALG/MODE/PADDING format.
   *
   * This class will only exist when the mode (*and its type*) is determinable.
   * This is because the mode will always be specified alongside the algorithm and never independently.
   * Therefore, we can always assume that a determinable algorithm will have a determinable mode.
   *
   * In the case that only an algorithm is specified, e.g., "AES", the provider provides a default mode.
   *
   * TODO: Model the case of relying on a provider default, but alert on it as a bad practice.
   */
  class ModeOfOperation extends Crypto::ModeOfOperationAlgorithm {
    CipherGetInstanceAlgorithmArg instance;

    ModeOfOperation() {
      this = Crypto::TBlockCipherModeOfOperationAlgorithm(instance) and
      // TODO: this currently only holds for explicitly defined modes in a string literal.
      // Cases with defaults, e.g., "AES", are not yet modelled.
      // For these cases, in a CBOM, the AES node would have an unknown edge to its mode child.
      exists(instance.getOrigin().getMode())
    }

    override Location getLocation() { result = instance.getLocation() }

    // In this case, the raw name is still only the /MODE/ part.
    // TODO: handle defaults
    override string getRawAlgorithmName() { result = instance.getOrigin().getMode() }

    private predicate modeToNameMappingKnown(Crypto::TBlockCipherModeOperationType type, string name) {
      type instanceof Crypto::ECB and name = "ECB"
      or
      type instanceof Crypto::CBC and name = "CBC"
      or
      type instanceof Crypto::GCM and name = "GCM"
      or
      type instanceof Crypto::CTR and name = "CTR"
      or
      type instanceof Crypto::XTS and name = "XTS"
      or
      type instanceof Crypto::CCM and name = "CCM"
      or
      type instanceof Crypto::SIV and name = "SIV"
      or
      type instanceof Crypto::OCB and name = "OCB"
    }

    override Crypto::TBlockCipherModeOperationType getModeType() {
      if this.modeToNameMappingKnown(_, instance.getOrigin().getMode())
      then this.modeToNameMappingKnown(result, instance.getOrigin().getMode())
      else result instanceof Crypto::OtherMode
    }

    CipherStringLiteral getInstance() { result = instance }
  }

  class PaddingAlgorithm extends Crypto::PaddingAlgorithm {
    CipherGetInstanceAlgorithmArg instance;

    PaddingAlgorithm() {
      this = Crypto::TPaddingAlgorithm(instance) and
      exists(instance.getOrigin().getPadding())
    }

    override Location getLocation() { result = instance.getLocation() }

    override string getRawAlgorithmName() { result = instance.getOrigin().getPadding() }

    bindingset[name]
    private predicate paddingToNameMappingKnown(Crypto::TPaddingType type, string name) {
      type instanceof Crypto::NoPadding and name = "NOPADDING"
      or
      type instanceof Crypto::PKCS7 and name = ["PKCS5Padding", "PKCS7Padding"] // TODO: misnomer in the JCA?
      or
      type instanceof Crypto::OAEP and name.matches("OAEP%") // TODO: handle OAEPWith%
    }

    override Crypto::TPaddingType getPaddingType() {
      if this.paddingToNameMappingKnown(_, instance.getOrigin().getPadding())
      then this.paddingToNameMappingKnown(result, instance.getOrigin().getPadding())
      else result instanceof Crypto::OtherPadding
    }

    CipherStringLiteral getInstance() { result = instance }
  }

  class EncryptionAlgorithm extends Crypto::CipherAlgorithm {
    CipherStringLiteral origin;
    CipherGetInstanceAlgorithmArg instance;

    EncryptionAlgorithm() {
      this = Crypto::TCipherAlgorithm(instance) and
      instance.getOrigin() = origin
    }

    override Location getLocation() { result = instance.getLocation() }

    override Crypto::ModeOfOperationAlgorithm getModeOfOperation() {
      result.(ModeOfOperation).getInstance() = origin
    }

    override Crypto::PaddingAlgorithm getPadding() {
      result.(PaddingAlgorithm).getInstance() = origin
    }

    override Crypto::LocatableElement getOrigin(string name) {
      result = origin and name = origin.toString()
    }

    override string getRawAlgorithmName() { result = origin.getValue() }

    override Crypto::TCipherType getCipherFamily() {
      if this.cipherNameMappingKnown(_, origin.getAlgorithmName())
      then this.cipherNameMappingKnown(result, origin.getAlgorithmName())
      else result instanceof Crypto::OtherCipherType
    }

    override string getKeySize(Location location) { none() }

    bindingset[name]
    private predicate cipherNameMappingKnown(Crypto::TCipherType type, string name) {
      name = "AES" and
      type instanceof Crypto::AES
      or
      name = "DES" and
      type instanceof Crypto::DES
      or
      name = "TripleDES" and
      type instanceof Crypto::TripleDES
      or
      name = "IDEA" and
      type instanceof Crypto::IDEA
      or
      name = "CAST5" and
      type instanceof Crypto::CAST5
      or
      name = "ChaCha20" and
      type instanceof Crypto::ChaCha20
      or
      name = "RC4" and
      type instanceof Crypto::RC4
      or
      name = "RC5" and
      type instanceof Crypto::RC5
      or
      name = "RSA" and
      type instanceof Crypto::RSA
    }
  }

  /**
   * Initialization vectors and other nonce artifacts
   */
  abstract class NonceParameterInstantiation extends Crypto::NonceArtifactInstance instanceof ClassInstanceExpr
  {
    override DataFlow::Node asOutputData() { result.asExpr() = this }
  }

  class IvParameterSpecInstance extends NonceParameterInstantiation {
    IvParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("javax.crypto.spec", "IvParameterSpec")
    }

    override DataFlow::Node getInput() { result.asExpr() = this.(ClassInstanceExpr).getArgument(0) }
  }

  // TODO: this also specifies the tag length for GCM
  class GCMParameterSpecInstance extends NonceParameterInstantiation {
    GCMParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("javax.crypto.spec", "GCMParameterSpec")
    }

    override DataFlow::Node getInput() { result.asExpr() = this.(ClassInstanceExpr).getArgument(1) }
  }

  class IvParameterSpecGetIvCall extends MethodCall {
    IvParameterSpecGetIvCall() {
      this.getMethod().hasQualifiedName("javax.crypto.spec", "IvParameterSpec", "getIV")
    }
  }

  module NonceArtifactToCipherInitCallConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) {
      exists(NonceParameterInstantiation n |
        src = n.asOutputData() and
        not exists(IvParameterSpecGetIvCall m | n.getInput().asExpr() = m)
      )
    }

    predicate isSink(DataFlow::Node sink) {
      exists(CipherInitCall c | c.getNonceArg() = sink.asExpr())
    }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      exists(IvParameterSpecGetIvCall m |
        node1.asExpr() = m.getQualifier() and
        node2.asExpr() = m
      )
      or
      exists(NonceParameterInstantiation n |
        node1 = n.getInput() and
        node2.asExpr() = n
      )
    }
  }

  module NonceArtifactToCipherInitCallFlow = DataFlow::Global<NonceArtifactToCipherInitCallConfig>;

  /**
   * A data-flow configuration to track flow from a mode field access to
   * the mode argument of the `init` method of the `javax.crypto.Cipher` class.
   */
  private module JavaxCipherModeAccessToInitConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) {
      src.asExpr() instanceof JavaxCryptoCipherOperationModeAccess
    }

    predicate isSink(DataFlow::Node sink) {
      exists(CipherInitCall c | c.getModeArg() = sink.asExpr())
    }
  }

  module JavaxCipherModeAccessToInitFlow = DataFlow::Global<JavaxCipherModeAccessToInitConfig>;

  private predicate cipher_mode_str_to_cipher_mode_known(
    string mode, Crypto::CipherOperationSubtype cipher_mode
  ) {
    mode = "ENCRYPT_MODE" and cipher_mode instanceof Crypto::EncryptionMode
    or
    mode = "WRAP_MODE" and cipher_mode instanceof Crypto::WrapMode
    or
    mode = "DECRYPT_MODE" and cipher_mode instanceof Crypto::DecryptionMode
    or
    mode = "UNWRAP_MODE" and cipher_mode instanceof Crypto::UnwrapMode
  }

  class CipherInitCall extends MethodCall {
    CipherInitCall() { this.getCallee().hasQualifiedName("javax.crypto", "Cipher", "init") }

    /**
     * Returns the mode argument to the `init` method
     * that is used to determine the cipher operation mode.
     * Note this is the raw expr and not necessarily a direct access
     * of a mode. Use `getModeOrigin()` to get the field access origin
     * flowing to this argument, if one exists (is known).
     */
    Expr getModeArg() { result = this.getArgument(0) }

    JavaxCryptoCipherOperationModeAccess getModeOrigin() {
      exists(DataFlow::Node src, DataFlow::Node sink |
        JavaxCipherModeAccessToInitFlow::flow(src, sink) and
        src.asExpr() = result and
        this.getModeArg() = sink.asExpr()
      )
    }

    Crypto::CipherOperationSubtype getCipherOperationModeType() {
      if cipher_mode_str_to_cipher_mode_known(this.getModeOrigin().getField().getName(), _)
      then cipher_mode_str_to_cipher_mode_known(this.getModeOrigin().getField().getName(), result)
      else result instanceof Crypto::UnknownCipherOperationMode
    }

    Expr getKeyArg() {
      result = this.getArgument(1) and this.getMethod().getParameterType(1).hasName("Key")
    }

    Expr getNonceArg() {
      result = this.getArgument(2) and
      this.getMethod().getParameterType(2).hasName("AlgorithmParameterSpec")
    }
  }
}
