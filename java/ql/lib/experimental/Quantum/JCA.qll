import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
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

  bindingset[hash]
  predicate hash_names(string hash) {
    hash.toUpperCase()
        .matches(["SHA-%", "SHA3-%", "BLAKE2b%", "BLAKE2s%", "MD5", "RIPEMD160", "Whirlpool"]
              .toUpperCase())
  }

  bindingset[kdf]
  predicate kdf_names(string kdf) {
    kdf.toUpperCase().matches(["PBKDF2With%", "PBEWith%"].toUpperCase())
  }

  bindingset[name]
  Crypto::TKeyDerivationType kdf_name_to_kdf_type(string name, string withSubstring) {
    name.matches("PBKDF2With%") and
    result instanceof Crypto::PBKDF2 and
    withSubstring = name.regexpCapture("PBKDF2With(.*)", 1)
    or
    name.matches("PBEWith%") and
    result instanceof Crypto::PBES and
    withSubstring = name.regexpCapture("PBEWith(.*)", 1)
  }

  bindingset[name]
  Crypto::THashType hash_name_to_hash_type(string name, int digestLength) {
    name = "SHA-1" and result instanceof Crypto::SHA1 and digestLength = 160
    or
    name = ["SHA-256", "SHA-384", "SHA-512"] and
    result instanceof Crypto::SHA2 and
    digestLength = name.splitAt("-", 1).toInt()
    or
    name = ["SHA3-224", "SHA3-256", "SHA3-384", "SHA3-512"] and
    result instanceof Crypto::SHA3 and
    digestLength = name.splitAt("-", 1).toInt()
    or
    (
      name.matches("BLAKE2b%") and
      result instanceof Crypto::BLAKE2B
      or
      name = "BLAKE2s" and result instanceof Crypto::BLAKE2S
    ) and
    (
      if exists(name.indexOf("-"))
      then name.splitAt("-", 1).toInt() = digestLength
      else digestLength = 512
    )
    or
    name = "MD5" and
    result instanceof Crypto::MD5 and
    digestLength = 128
    or
    name = "RIPEMD160" and
    result instanceof Crypto::RIPEMD160 and
    digestLength = 160
    or
    name = "Whirlpool" and
    result instanceof Crypto::WHIRLPOOL and
    digestLength = 512 // TODO: verify
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

  private class CipherOperationCall extends MethodCall {
    CipherOperationCall() {
      exists(string s | s in ["doFinal", "wrap", "unwrap"] |
        this.getMethod().hasQualifiedName("javax.crypto", "Cipher", s)
      )
    }

    Expr getInput() { result = this.getArgument(0) }

    Expr getOutput() {
      result = this.getArgument(3)
      or
      this.getMethod().getReturnType().hasName("byte[]") and result = this
    }

    DataFlow::Node getMessageArg() { result.asExpr() = this.getInput() }
  }

  /**
   * Data-flow configuration modelling flow from a cipher string literal to a `CipherGetInstanceCall` argument.
   */
  private module AlgorithmStringToFetchConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CipherStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      exists(Crypto::AlgorithmValueConsumer consumer | sink = consumer.getInputNode())
    }
  }

  module AlgorithmStringToFetchFlow = TaintTracking::Global<AlgorithmStringToFetchConfig>;

  /**
   * Note: padding and a mode of operation will only exist when the padding / mode (*and its type*) are determinable.
   * This is because the mode will always be specified alongside the algorithm and never independently.
   * Therefore, we can always assume that a determinable algorithm will have a determinable mode.
   *
   * In the case that only an algorithm is specified, e.g., "AES", the provider provides a default mode.
   *
   * TODO: Model the case of relying on a provider default, but alert on it as a bad practice.
   */
  class CipherStringLiteralPaddingAlgorithmInstance extends CipherStringLiteralAlgorithmInstance,
    Crypto::PaddingAlgorithmInstance instanceof CipherStringLiteral
  {
    CipherStringLiteralPaddingAlgorithmInstance() { exists(super.getPadding()) } // TODO: provider defaults

    override string getRawPaddingAlgorithmName() { result = super.getPadding() }

    bindingset[name]
    private predicate paddingToNameMappingKnown(Crypto::TPaddingType type, string name) {
      type instanceof Crypto::NoPadding and name = "NOPADDING"
      or
      type instanceof Crypto::PKCS7 and name = ["PKCS5Padding", "PKCS7Padding"] // TODO: misnomer in the JCA?
      or
      type instanceof Crypto::OAEP and name.matches("OAEP%") // TODO: handle OAEPWith%
    }

    override Crypto::TPaddingType getPaddingType() {
      if this.paddingToNameMappingKnown(_, super.getPadding())
      then this.paddingToNameMappingKnown(result, super.getPadding())
      else result instanceof Crypto::OtherPadding
    }
  }

  class CipherStringLiteralModeAlgorithmInstance extends CipherStringLiteralPaddingAlgorithmInstance,
    Crypto::ModeOfOperationAlgorithmInstance instanceof CipherStringLiteral
  {
    CipherStringLiteralModeAlgorithmInstance() { exists(super.getMode()) } // TODO: provider defaults

    override string getRawModeAlgorithmName() { result = super.getMode() }

    bindingset[name]
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
      if this.modeToNameMappingKnown(_, super.getMode())
      then this.modeToNameMappingKnown(result, super.getMode())
      else result instanceof Crypto::OtherMode
    }
  }

  class CipherStringLiteralAlgorithmInstance extends Crypto::CipherAlgorithmInstance instanceof CipherStringLiteral
  {
    Crypto::AlgorithmValueConsumer consumer;

    CipherStringLiteralAlgorithmInstance() {
      AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(this), consumer.getInputNode())
    }

    Crypto::AlgorithmValueConsumer getConsumer() { result = consumer }

    override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() {
      result = this // TODO: provider defaults
    }

    override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() {
      result = this // TODO: provider defaults
    }

    override string getRawCipherAlgorithmName() { result = super.getValue() }

    override Crypto::TCipherType getCipherFamily() {
      if this.cipherNameMappingKnown(_, super.getAlgorithmName())
      then this.cipherNameMappingKnown(result, super.getAlgorithmName())
      else result instanceof Crypto::OtherCipherType
    }

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
      type instanceof Crypto::CHACHA20
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

  bindingset[input]
  predicate oaep_padding_string_components(string input, string hash, string mfg) {
    exists(string regex |
      regex = "OAEPWith(.*)And(.*)Padding" and
      hash = input.regexpCapture(regex, 1) and
      mfg = input.regexpCapture(regex, 2)
    )
  }

  predicate oaep_padding_string_components_eval(string hash, string mfg) {
    oaep_padding_string_components(any(CipherStringLiteral s).getPadding(), hash, mfg)
  }

  class OAEPPaddingHashAlgorithmInstance extends OAEPPaddingAlgorithmInstance,
    Crypto::HashAlgorithmInstance instanceof CipherStringLiteral
  {
    string hashName;

    OAEPPaddingHashAlgorithmInstance() {
      oaep_padding_string_components(super.getPadding(), hashName, _)
    }

    override string getRawHashAlgorithmName() { result = super.getPadding() }

    override Crypto::THashType getHashFamily() { result = hash_name_to_hash_type(hashName, _) }

    override int getDigestLength() { exists(hash_name_to_hash_type(hashName, result)) }
  }

  class OAEPPaddingAlgorithmInstance extends Crypto::OAEPPaddingAlgorithmInstance,
    CipherStringLiteralPaddingAlgorithmInstance
  {
    override Crypto::HashAlgorithmInstance getOAEPEncodingHashAlgorithm() { result = this }

    override Crypto::HashAlgorithmInstance getMGF1HashAlgorithm() { none() } // TODO
  }

  /**
   * The cipher algorithm argument to a `CipherGetInstanceCall`.
   *
   * For example, in `Cipher.getInstance(algorithm)`, this class represents `algorithm`.
   */
  class CipherGetInstanceAlgorithmArg extends Crypto::AlgorithmValueConsumer instanceof Expr {
    CipherGetInstanceCall call;

    CipherGetInstanceAlgorithmArg() { this = call.getAlgorithmArg() }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

    CipherStringLiteral getOrigin(string value) {
      AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(result),
        DataFlow::exprNode(this.(Expr).getAChildExpr*())) and
      value = result.getValue()
    }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
      result.(CipherStringLiteralAlgorithmInstance).getConsumer() = this
    }
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

  private newtype TCipherModeFlowState =
    TUninitializedCipherModeFlowState() or
    TInitializedCipherModeFlowState(CipherInitCall call) or
    TUsedCipherModeFlowState(CipherInitCall init)

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
      result instanceof Crypto::UnknownCipherOperationSubtype
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

    predicate isSink(DataFlow::Node sink, FlowState state) { none() } // TODO: document this, but this is intentional (avoid cross products?)

    predicate isSink(DataFlow::Node sink) {
      exists(CipherOperationCall c | c.getQualifier() = sink.asExpr())
    }

    predicate isAdditionalFlowStep(
      DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
    ) {
      state1 = state1 and
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
    CipherGetInstanceToCipherOperationFlow::PathNode sink;
    CipherOperationCall doFinalize;
    CipherGetInstanceAlgorithmArg consumer;

    CipherOperationInstance() {
      exists(CipherGetInstanceToCipherOperationFlow::PathNode src, CipherGetInstanceCall getCipher |
        CipherGetInstanceToCipherOperationFlow::flowPath(src, sink) and
        src.getNode().asExpr() = getCipher and
        sink.getNode().asExpr() = doFinalize.getQualifier() and
        sink.getState().(CipherModeFlowState).getCipherOperationMode() = mode and
        this = doFinalize and
        consumer = getCipher.getAlgorithmArg()
      )
    }

    override Crypto::CipherOperationSubtype getCipherOperationSubtype() { result = mode }

    override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
      result.asExpr() = sink.getState().(InitializedCipherModeFlowState).getInitCall().getNonceArg()
    }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      result = doFinalize.getMessageArg()
    }

    override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
      result.asExpr() = sink.getState().(InitializedCipherModeFlowState).getInitCall().getKeyArg()
    }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() { result = consumer }

    override Crypto::CipherOutputArtifactInstance getOutputArtifact() {
      result = doFinalize.getOutput()
    }
  }

  /**
   * Initialization vectors and other nonce artifacts
   */
  abstract class NonceParameterInstantiation extends ClassInstanceExpr {
    DataFlow::Node getOutputNode() { result.asExpr() = this }

    abstract DataFlow::Node getInputNode();
  }

  class IvParameterSpecInstance extends NonceParameterInstantiation {
    IvParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("javax.crypto.spec", "IvParameterSpec")
    }

    override DataFlow::Node getInputNode() {
      result.asExpr() = this.(ClassInstanceExpr).getArgument(0)
    }
  }

  // TODO: this also specifies the tag length for GCM
  class GCMParameterSpecInstance extends NonceParameterInstantiation {
    GCMParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("javax.crypto.spec", "GCMParameterSpec")
    }

    override DataFlow::Node getInputNode() {
      result.asExpr() = this.(ClassInstanceExpr).getArgument(1)
    }
  }

  class IvParameterSpecGetIvCall extends MethodCall {
    IvParameterSpecGetIvCall() {
      this.getMethod().hasQualifiedName("javax.crypto.spec", "IvParameterSpec", "getIV")
    }
  }

  // e.g., getPublic or getPrivate
  class KeyAdditionalFlowSteps extends MethodCall {
    KeyAdditionalFlowSteps() {
      this.getCallee().hasQualifiedName("java.security", "KeyPair", "getPublic")
      or
      this.getCallee().hasQualifiedName("java.security", "KeyPair", "getPrivate")
      or
      this.getCallee().hasQualifiedName("java.security", "Key", "getEncoded")
    }

    DataFlow::Node getInputNode() { result.asExpr() = this.getQualifier() }

    DataFlow::Node getOutputNode() { result.asExpr() = this }
  }

  predicate additionalFlowSteps(DataFlow::Node node1, DataFlow::Node node2) {
    exists(IvParameterSpecGetIvCall m |
      node1.asExpr() = m.getQualifier() and
      node2.asExpr() = m
    )
    or
    exists(NonceParameterInstantiation n |
      node1 = n.getInputNode() and
      node2 = n.getOutputNode()
    )
    or
    exists(KeyAdditionalFlowSteps call |
      node1 = call.getInputNode() and
      node2 = call.getOutputNode()
    )
  }

  class ArtifactAdditionalFlowStep extends AdditionalFlowInputStep {
    DataFlow::Node output;

    ArtifactAdditionalFlowStep() { additionalFlowSteps(this, output) }

    override DataFlow::Node getOutput() { result = output }
  }

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
    mode = "ENCRYPT_MODE" and cipher_mode instanceof Crypto::EncryptionSubtype
    or
    mode = "WRAP_MODE" and cipher_mode instanceof Crypto::WrapSubtype
    or
    mode = "DECRYPT_MODE" and cipher_mode instanceof Crypto::DecryptionSubtype
    or
    mode = "UNWRAP_MODE" and cipher_mode instanceof Crypto::UnwrapSubtype
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
      else result instanceof Crypto::UnknownCipherOperationSubtype
    }

    Expr getKeyArg() {
      result = this.getArgument(1) and this.getMethod().getParameterType(1).hasName("Key")
    }

    Expr getNonceArg() {
      result = this.getArgument(2) and
      this.getMethod().getParameterType(2).hasName("AlgorithmParameterSpec")
    }
  }

  class CipherInitCallKeyConsumer extends Crypto::ArtifactConsumer {
    CipherInitCallKeyConsumer() { this = any(CipherInitCall call).getKeyArg() }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }
  }

  class CipherOperationCallOutput extends Crypto::CipherOutputArtifactInstance {
    CipherOperationCallOutput() { this = any(CipherOperationCall call).getOutput() }

    override DataFlow::Node getOutputNode() { result.asExpr() = this }
  }

  // flow config from a known hash algorithm literal to MessageDigest.getInstance
  module KnownHashAlgorithmLiteralToMessageDigestConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { hash_names(src.asExpr().(StringLiteral).getValue()) }

    predicate isSink(DataFlow::Node sink) {
      exists(MessageDigestGetInstanceCall call | sink.asExpr() = call.getAlgorithmArg())
    }
  }

  module KnownHashAlgorithmLiteralToMessageDigestFlow =
    DataFlow::Global<KnownHashAlgorithmLiteralToMessageDigestConfig>;

  class KnownHashAlgorithm extends Crypto::HashAlgorithmInstance instanceof StringLiteral {
    MessageDigestAlgorithmValueConsumer consumer;

    KnownHashAlgorithm() {
      hash_names(this.getValue()) and
      KnownHashAlgorithmLiteralToMessageDigestFlow::flow(DataFlow::exprNode(this),
        consumer.getInputNode())
    }

    MessageDigestAlgorithmValueConsumer getConsumer() { result = consumer }

    override string getRawHashAlgorithmName() { result = this.(StringLiteral).getValue() }

    override Crypto::THashType getHashFamily() {
      result = hash_name_to_hash_type(this.getRawHashAlgorithmName(), _)
    }

    override int getDigestLength() {
      exists(hash_name_to_hash_type(this.getRawHashAlgorithmName(), result))
    }
  }

  class MessageDigestAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
    MessageDigestGetInstanceCall call;

    MessageDigestAlgorithmValueConsumer() { this = call.getAlgorithmArg() }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
      exists(KnownHashAlgorithm l | l.getConsumer() = this and result = l)
    }
  }

  class MessageDigestGetInstanceCall extends MethodCall {
    MessageDigestGetInstanceCall() {
      this.getCallee().hasQualifiedName("java.security", "MessageDigest", "getInstance")
    }

    Expr getAlgorithmArg() { result = this.getArgument(0) }

    DigestHashOperation getDigestCall() {
      DigestGetInstanceToDigestFlow::flow(DataFlow::exprNode(this),
        DataFlow::exprNode(result.(DigestCall).getQualifier()))
    }
  }

  class DigestCall extends MethodCall {
    DigestCall() { this.getCallee().hasQualifiedName("java.security", "MessageDigest", "digest") }

    Expr getDigestArtifactOutput() { result = this }
  }

  // flow config from MessageDigest.getInstance to MessageDigest.digest
  module DigestGetInstanceToDigestConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof MessageDigestGetInstanceCall }

    predicate isSink(DataFlow::Node sink) {
      exists(DigestCall c | c.getQualifier() = sink.asExpr())
    }
  }

  module DigestGetInstanceToDigestFlow = DataFlow::Global<DigestGetInstanceToDigestConfig>;

  class DigestArtifact extends Crypto::DigestArtifactInstance {
    DigestArtifact() { this = any(DigestCall call).getDigestArtifactOutput() }

    override DataFlow::Node getOutputNode() { result.asExpr() = this }
  }

  class DigestHashOperation extends Crypto::HashOperationInstance instanceof DigestCall {
    override Crypto::DigestArtifactInstance getDigestArtifact() {
      result = this.(DigestCall).getDigestArtifactOutput()
    }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      exists(MessageDigestGetInstanceCall call |
        call.getDigestCall() = this and result = call.getAlgorithmArg()
      )
    }
  }

  class KeyGeneratorCallAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
    KeyGeneratorGetInstanceCall call;

    KeyGeneratorCallAlgorithmValueConsumer() { this = call.getAlgorithmArg() }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
      result.(CipherStringLiteralAlgorithmInstance).getConsumer() = this
    }
  }

  // flow from instance created by getInstance to generateKey
  module KeyGeneratorGetInstanceToGenerateConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) {
      exists(KeyGeneratorGetInstanceCall call | src.asExpr() = call)
    }

    predicate isSink(DataFlow::Node sink) {
      exists(KeyGeneratorGenerateCall call | sink.asExpr() = call.(MethodCall).getQualifier())
    }
  }

  module KeyGeneratorGetInstanceToGenerateFlow =
    DataFlow::Global<KeyGeneratorGetInstanceToGenerateConfig>;

  class KeyGeneratorGetInstanceCall extends MethodCall {
    KeyGeneratorGetInstanceCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "KeyGenerator", "getInstance")
      or
      this.getCallee().hasQualifiedName("java.security", "KeyPairGenerator", "getInstance")
    }

    Expr getAlgorithmArg() { result = super.getArgument(0) }

    predicate flowsToKeyGenerateCallQualifier(KeyGeneratorGenerateCall sink) {
      KeyGeneratorGetInstanceToGenerateFlow::flow(DataFlow::exprNode(this),
        DataFlow::exprNode(sink.(MethodCall).getQualifier()))
    }
  }

  class KeyGeneratorGenerateCall extends Crypto::KeyGenerationOperationInstance instanceof MethodCall
  {
    Crypto::KeyArtifactType type;

    KeyGeneratorGenerateCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "KeyGenerator", "generateKey") and
      type instanceof Crypto::TSymmetricKeyType
      or
      this.getCallee().hasQualifiedName("java.security", "KeyPairGenerator", "generateKeyPair") and
      type instanceof Crypto::TAsymmetricKeyType
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() { result.asExpr() = this }

    override Crypto::KeyArtifactType getOutputKeyType() { result = type }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      exists(KeyGeneratorGetInstanceCall getInstance |
        getInstance.flowsToKeyGenerateCallQualifier(this) and result = getInstance.getAlgorithmArg()
      )
    }

    Crypto::AlgorithmInstance getAKnownAlgorithm() {
      result = this.getAnAlgorithmValueConsumer().getAKnownAlgorithmSource()
    }

    override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

    override string getKeySizeFixed() { none() }
  }

  /*
   * TODO:
   *
   * MAC Algorithms possible (JCA Default + BouncyCastle Extensions)
   *
   * Name              Type             Description
   * ---------------------------------------------------------------------------
   * "HmacMD5"         HMAC             HMAC with MD5 (not recommended)
   * "HmacSHA1"        HMAC             HMAC with SHA-1 (not recommended)
   * "HmacSHA224"      HMAC             HMAC with SHA-224
   * "HmacSHA256"      HMAC             HMAC with SHA-256
   * "HmacSHA384"      HMAC             HMAC with SHA-384
   * "HmacSHA512"      HMAC             HMAC with SHA-512
   *
   * (BouncyCastle and Other Provider Extensions)
   * "AESCMAC"         CMAC             Cipher-based MAC using AES
   * "DESCMAC"         CMAC             CMAC with DES (legacy)
   * "GMAC"            GCM-based MAC    Authenticates AAD only (GCM-style)
   * "Poly1305"        AEAD-style MAC   Used with ChaCha20
   * "SipHash"         Hash-based MAC   Fast MAC for short inputs
   * "BLAKE2BMAC"      HMAC-style       BLAKE2b MAC (cryptographic hash)
   * "HmacRIPEMD160"   HMAC             HMAC with RIPEMD160 hash
   */

  bindingset[name]
  predicate mac_names(string name) {
    name.toUpperCase()
        .matches([
            "HMAC%", "AESCMAC", "DESCMAC", "GMAC", "Poly1305", "SipHash", "BLAKE2BMAC",
            "HMACRIPEMD160"
          ].toUpperCase())
  }

  bindingset[name]
  predicate mac_name_to_mac_type_known(Crypto::TMACType type, string name) {
    type instanceof Crypto::THMAC and
    name.toUpperCase().matches("HMAC%")
  }

  module MACKnownAlgorithmToConsumerConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { mac_names(src.asExpr().(StringLiteral).getValue()) }

    predicate isSink(DataFlow::Node sink) {
      exists(MACGetInstanceCall call | sink.asExpr() = call.getAlgorithmArg())
    }
  }

  module MACKnownAlgorithmToConsumerFlow = DataFlow::Global<MACKnownAlgorithmToConsumerConfig>;

  module MACGetInstanceToMACOperationFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof MACGetInstanceCall }

    predicate isSink(DataFlow::Node sink) {
      exists(MACOperationCall call | sink.asExpr() = call.(MethodCall).getQualifier()) or
      exists(MACInitCall call | sink.asExpr() = call.(MethodCall).getQualifier())
    }
  }

  module MACGetInstanceToMACOperationFlow =
    DataFlow::Global<MACGetInstanceToMACOperationFlowConfig>;

  module MACInitCallToMACOperationFlowConfig implements DataFlow::ConfigSig {
    // TODO: use flow state with one config
    predicate isSource(DataFlow::Node src) {
      exists(MACInitCall init | src.asExpr() = init.getQualifier())
    }

    predicate isSink(DataFlow::Node sink) {
      exists(MACOperationCall call | sink.asExpr() = call.(MethodCall).getQualifier())
    }
  }

  module MACInitCallToMACOperationFlow = DataFlow::Global<MACInitCallToMACOperationFlowConfig>;

  class KnownMACAlgorithm extends Crypto::MACAlgorithmInstance instanceof StringLiteral {
    MACGetInstanceAlgorithmValueConsumer consumer;

    KnownMACAlgorithm() {
      mac_names(this.getValue()) and
      MACKnownAlgorithmToConsumerFlow::flow(DataFlow::exprNode(this), consumer.getInputNode())
    }

    MACGetInstanceAlgorithmValueConsumer getConsumer() { result = consumer }

    override string getRawMACAlgorithmName() { result = super.getValue() }

    override Crypto::TMACType getMACType() {
      if mac_name_to_mac_type_known(_, super.getValue())
      then mac_name_to_mac_type_known(result, super.getValue())
      else result instanceof Crypto::TOtherMACType
    }
  }

  class MACGetInstanceCall extends MethodCall {
    MACGetInstanceCall() { this.getCallee().hasQualifiedName("javax.crypto", "Mac", "getInstance") }

    Expr getAlgorithmArg() { result = this.getArgument(0) }

    MACOperationCall getOperation() {
      MACGetInstanceToMACOperationFlow::flow(DataFlow::exprNode(this),
        DataFlow::exprNode(result.(MethodCall).getQualifier()))
    }

    MACInitCall getInitCall() {
      MACGetInstanceToMACOperationFlow::flow(DataFlow::exprNode(this),
        DataFlow::exprNode(result.getQualifier()))
    }
  }

  class MACInitCall extends MethodCall {
    MACInitCall() { this.getCallee().hasQualifiedName("javax.crypto", "Mac", "init") }

    Expr getKeyArg() {
      result = this.getArgument(0) and this.getMethod().getParameterType(0).hasName("Key")
    }

    MACOperationCall getOperation() {
      MACInitCallToMACOperationFlow::flow(DataFlow::exprNode(this.getQualifier()),
        DataFlow::exprNode(result.(MethodCall).getQualifier()))
    }
  }

  class MACGetInstanceAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
    MACGetInstanceCall call;

    MACGetInstanceAlgorithmValueConsumer() { this = call.getAlgorithmArg() }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
      exists(KnownMACAlgorithm l | l.getConsumer() = this and result = l)
    }
  }

  class MACOperationCall extends Crypto::MACOperationInstance instanceof MethodCall {
    Expr output;

    MACOperationCall() {
      super.getMethod().getDeclaringType().hasQualifiedName("javax.crypto", "Mac") and
      (
        super.getMethod().hasStringSignature(["doFinal()", "doFinal(byte[])"]) and this = output
        or
        super.getMethod().hasStringSignature("doFinal(byte[], int)") and
        this.getArgument(0) = output
      )
    }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      exists(MACGetInstanceCall instantiation |
        instantiation.getOperation() = this and result = instantiation.getAlgorithmArg()
      )
    }

    override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
      exists(MACGetInstanceCall instantiation, MACInitCall initCall |
        instantiation.getOperation() = this and
        initCall.getOperation() = this and
        instantiation.getInitCall() = initCall and
        result.asExpr() = initCall.getKeyArg()
      )
    }

    override Crypto::ConsumerInputDataFlowNode getMessageConsumer() {
      result.asExpr() = super.getArgument(0) and
      super.getMethod().getParameterType(0).hasName("byte[]")
    }
  }

  module SecretKeyFactoryGetInstanceToGenerateSecretFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) {
      exists(SecretKeyFactoryGetInstanceCall call | src.asExpr() = call)
    }

    predicate isSink(DataFlow::Node sink) {
      exists(SecretKeyFactoryGenerateSecretCall call |
        sink.asExpr() = call.(MethodCall).getQualifier()
      )
    }
  }

  module PBEKeySpecInstantiationToGenerateSecretFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) {
      exists(PBEKeySpecInstantiation call | src.asExpr() = call)
    }

    predicate isSink(DataFlow::Node sink) {
      exists(SecretKeyFactoryGenerateSecretCall call | sink.asExpr() = call.getKeySpecArg())
    }
  }

  module KDFAlgorithmStringToGetInstanceConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { kdf_names(src.asExpr().(StringLiteral).getValue()) }

    predicate isSink(DataFlow::Node sink) {
      exists(SecretKeyFactoryGetInstanceCall call | sink.asExpr() = call.getAlgorithmArg())
    }
  }

  module SecretKeyFactoryGetInstanceToGenerateSecretFlow =
    DataFlow::Global<SecretKeyFactoryGetInstanceToGenerateSecretFlowConfig>;

  module PBEKeySpecInstantiationToGenerateSecretFlow =
    DataFlow::Global<PBEKeySpecInstantiationToGenerateSecretFlowConfig>;

  module KDFAlgorithmStringToGetInstanceFlow =
    DataFlow::Global<KDFAlgorithmStringToGetInstanceConfig>;

  class PBEKeySpecInstantiation extends ClassInstanceExpr {
    PBEKeySpecInstantiation() {
      this.getConstructedType().hasQualifiedName("javax.crypto.spec", "PBEKeySpec")
    }

    Expr getPasswordArg() { result = this.getArgument(0) }

    Expr getSaltArg() { result = this.getArgument(1) }

    Expr getIterationCountArg() { result = this.getArgument(2) }

    Expr getKeyLengthArg() { result = this.getArgument(3) }
  }

  class SecretKeyFactoryGetInstanceCall extends MethodCall {
    SecretKeyFactoryGetInstanceCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "SecretKeyFactory", "getInstance")
    }

    Expr getAlgorithmArg() { result = this.getArgument(0) }

    SecretKeyFactoryGenerateSecretCall getOperation() {
      SecretKeyFactoryGetInstanceToGenerateSecretFlow::flow(DataFlow::exprNode(this),
        DataFlow::exprNode(result.(MethodCall).getQualifier()))
    }
  }

  class KDFAlgorithmStringLiteral extends Crypto::KeyDerivationAlgorithmInstance instanceof StringLiteral
  {
    SecretKeyFactoryKDFAlgorithmValueConsumer consumer;

    KDFAlgorithmStringLiteral() {
      kdf_names(this.getValue()) and
      KDFAlgorithmStringToGetInstanceFlow::flow(DataFlow::exprNode(this), consumer.getInputNode())
    }

    override string getRawKDFAlgorithmName() { result = super.getValue() }

    override Crypto::TKeyDerivationType getKDFType() {
      result = kdf_name_to_kdf_type(super.getValue(), _)
    }

    SecretKeyFactoryKDFAlgorithmValueConsumer getConsumer() { result = consumer }
  }

  class PBKDF2AlgorithmStringLiteral extends KDFAlgorithmStringLiteral,
    Crypto::PBKDF2AlgorithmInstance, Crypto::HMACAlgorithmInstance, Crypto::HashAlgorithmInstance,
    Crypto::AlgorithmValueConsumer
  {
    PBKDF2AlgorithmStringLiteral() { super.getKDFType() instanceof Crypto::PBKDF2 }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

    override Crypto::THashType getHashFamily() {
      result = hash_name_to_hash_type(this.getRawHashAlgorithmName(), _)
    }

    override int getDigestLength() {
      exists(hash_name_to_hash_type(this.getRawHashAlgorithmName(), result))
    }

    override string getRawMACAlgorithmName() {
      result = super.getRawKDFAlgorithmName().splitAt("PBKDF2With", 1)
    }

    override string getRawHashAlgorithmName() {
      result = super.getRawKDFAlgorithmName().splitAt("WithHmac", 1)
    }

    override Crypto::TMACType getMACType() { result instanceof Crypto::THMAC }

    override Crypto::AlgorithmValueConsumer getHMACAlgorithmValueConsumer() { result = this }

    override Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() { result = this }
  }

  class SecretKeyFactoryKDFAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer instanceof Expr
  {
    SecretKeyFactoryGetInstanceCall call;

    SecretKeyFactoryKDFAlgorithmValueConsumer() { this = call.getAlgorithmArg() }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
      exists(KDFAlgorithmStringLiteral l | l.getConsumer() = this and result = l)
    }

    SecretKeyFactoryGetInstanceCall getInstantiation() { result = call }
  }

  class SecretKeyFactoryGenerateSecretCall extends Crypto::KeyDerivationOperationInstance instanceof MethodCall
  {
    SecretKeyFactoryGenerateSecretCall() {
      super.getCallee().hasQualifiedName("javax.crypto", "SecretKeyFactory", "generateSecret")
    }

    Expr getKeySpecArg() {
      result = super.getArgument(0) and
      super.getMethod().getParameterType(0).hasName("KeySpec")
    }

    PBEKeySpecInstantiation getInstantiation() {
      PBEKeySpecInstantiationToGenerateSecretFlow::flow(DataFlow::exprNode(result),
        DataFlow::exprNode(this.getKeySpecArg()))
    }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      exists(SecretKeyFactoryGetInstanceCall instantiation |
        instantiation.getOperation() = this and result = instantiation.getAlgorithmArg()
      )
    }

    override Crypto::ConsumerInputDataFlowNode getSaltConsumer() {
      result.asExpr() = this.getInstantiation().getSaltArg()
    }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      result.asExpr() = this.getInstantiation().getPasswordArg()
    }

    override Crypto::ConsumerInputDataFlowNode getIterationCountConsumer() {
      result.asExpr() = this.getInstantiation().getIterationCountArg()
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() {
      result.asExpr() = this and
      super.getMethod().getReturnType().hasName("SecretKey")
    }

    override Crypto::ConsumerInputDataFlowNode getOutputKeySizeConsumer() {
      result.asExpr() = this.getInstantiation().getKeyLengthArg()
    }

    override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
      result.asExpr() = this.getInstantiation().getKeyLengthArg()
    }

    override string getKeySizeFixed() { none() }

    override string getOutputKeySizeFixed() { none() }

    override string getIterationCountFixed() { none() }
  }
}
