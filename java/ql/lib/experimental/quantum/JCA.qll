import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.controlflow.Dominance

module JCAModel {
  import Language
  import Crypto::KeyOpAlg as KeyOpAlg

  abstract class CipherAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

  abstract class EllipticCurveAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

  abstract class HashAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

  abstract class KeyAgreementAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

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
  predicate elliptic_curve_names(string name) {
    // Note: as a one-off exception, we use the internal Crypto module implementation of `isEllipticCurveAlgorithmName`
    Crypto::isEllipticCurveAlgorithmName(name)
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
  predicate key_agreement_names(string name) {
    name.toUpperCase().matches(["DH", "EDH", "ECDH", "X25519", "X448"].toUpperCase())
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
    // TODO: add additional
  }

  bindingset[name]
  Crypto::THashType hash_name_to_type_known(string name, int digestLength) {
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

  bindingset[name]
  private predicate mode_name_to_type_known(
    Crypto::TBlockCipherModeOfOperationType type, string name
  ) {
    type = Crypto::ECB() and name = "ECB"
    or
    type = Crypto::CBC() and name = "CBC"
    or
    type = Crypto::GCM() and name = "GCM"
    or
    type = Crypto::CTR() and name = "CTR"
    or
    type = Crypto::XTS() and name = "XTS"
    or
    type = Crypto::CCM() and name = "CCM"
    or
    type = Crypto::SIV() and name = "SIV"
    or
    type = Crypto::OCB() and name = "OCB"
  }

  bindingset[name]
  private predicate cipher_name_to_type_known(KeyOpAlg::TAlgorithm type, string name) {
    exists(string upper | upper = name.toUpperCase() |
      upper.matches("AES%") and
      type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::AES())
      or
      upper = "DES" and
      type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DES())
      or
      upper = "TRIPLEDES" and
      type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::TripleDES())
      or
      upper = "IDEA" and
      type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::IDEA())
      or
      upper = "CAST5" and
      type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::CAST5())
      or
      upper = "CHACHA20" and
      type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::CHACHA20())
      or
      upper = "RC4" and
      type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC4())
      or
      upper = "RC5" and
      type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC5())
      or
      upper = "RSA" and
      type = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA())
    )
  }

  bindingset[name]
  predicate mac_name_to_mac_type_known(Crypto::TMACType type, string name) {
    type = Crypto::THMAC() and
    name.toUpperCase().matches("HMAC%")
  }

  bindingset[name]
  predicate key_agreement_name_to_type_known(Crypto::TKeyAgreementType type, string name) {
    type = Crypto::DH() and
    name.toUpperCase() = "DH"
    or
    type = Crypto::EDH() and
    name.toUpperCase() = "EDH"
    or
    type = Crypto::ECDH() and
    name.toUpperCase() in ["ECDH", "X25519", "X448"]
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

  class CipherGetInstanceCall extends MethodCall {
    CipherGetInstanceCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "Cipher", "getInstance")
    }

    Expr getAlgorithmArg() { result = this.getArgument(0) }

    Expr getProviderArg() { result = this.getArgument(1) }
  }

  // TODO: handle key artifact produced by unwrap
  private class CipherOperationCall extends MethodCall {
    CipherOperationCall() {
      this.getMethod()
          .hasQualifiedName("javax.crypto", "Cipher", ["update", "doFinal", "wrap", "unwrap"])
    }

    predicate isIntermediate() { this.getMethod().getName() = "update" }

    Expr getInput() { result = this.getArgument(0) }

    Expr getOutput() {
      exists(int outputIndex | this.getMethod().getParameter(outputIndex).getName() = "output" |
        result = this.getArgument(outputIndex)
      )
      or
      this.getMethod().getReturnType().hasName("byte[]") and result = this
    }

    DataFlow::Node getMessageArg() { result.asExpr() = this.getInput() }
  }

  /**
   * Data-flow configuration modelling flow from a cipher string literal to a cipher algorithm consumer.
   */
  private module CipherAlgorithmStringToCipherConsumerConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CipherStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      sink = any(CipherAlgorithmValueConsumer call).getInputNode()
    }
  }

  module CipherAlgorithmStringToFetchFlow =
    TaintTracking::Global<CipherAlgorithmStringToCipherConsumerConfig>;

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

    override Crypto::TBlockCipherModeOfOperationType getModeType() {
      if mode_name_to_type_known(_, super.getMode())
      then mode_name_to_type_known(result, super.getMode())
      else result instanceof Crypto::OtherMode
    }
  }

  class CipherStringLiteralAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance instanceof CipherStringLiteral
  {
    CipherAlgorithmValueConsumer consumer;

    CipherStringLiteralAlgorithmInstance() {
      CipherAlgorithmStringToFetchFlow::flow(DataFlow::exprNode(this), consumer.getInputNode())
    }

    CipherAlgorithmValueConsumer getConsumer() { result = consumer }

    override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() {
      result = this // TODO: provider defaults
    }

    override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() {
      result = this // TODO: provider defaults
    }

    override string getRawAlgorithmName() { result = super.getValue() }

    override KeyOpAlg::Algorithm getAlgorithmType() {
      if cipher_name_to_type_known(_, super.getAlgorithmName())
      then cipher_name_to_type_known(result, super.getAlgorithmName())
      else result instanceof KeyOpAlg::TUnknownKeyOperationAlgorithmType
    }

    override string getKeySizeFixed() {
      none() // TODO: implement to handle variants such as AES-128
    }

    override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }
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

    override Crypto::THashType getHashFamily() { result = hash_name_to_type_known(hashName, _) }

    override int getFixedDigestLength() { exists(hash_name_to_type_known(hashName, result)) }
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
  class CipherGetInstanceAlgorithmArg extends CipherAlgorithmValueConsumer instanceof Expr {
    CipherGetInstanceCall call;

    CipherGetInstanceAlgorithmArg() { this = call.getAlgorithmArg() }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

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

  signature class GetInstanceCallSig instanceof MethodCall;

  signature class InitCallSig instanceof MethodCall;

  signature class UseCallSig instanceof MethodCall {
    /**
     * Holds if the use is not a final use, such as an `update()` call before `doFinal()`
     */
    predicate isIntermediate();
  }

  /**
   * An generic analysis module for analyzing the `getInstance` to `initialize` to `doOperation` pattern in the JCA.
   *
   * For example:
   * ```
   * kpg = KeyPairGenerator.getInstance();
   * kpg.initialize(...);
   * kpg.generate(...);
   * ```
   */
  module GetInstanceInitUseFlowAnalysis<
    GetInstanceCallSig GetInstance, InitCallSig Init, UseCallSig Use>
  {
    newtype TFlowState =
      TUninitialized() or
      TInitialized(Init call) or
      TIntermediateUse(Use call)

    abstract class InitFlowState extends TFlowState {
      string toString() {
        this = TUninitialized() and result = "Uninitialized"
        or
        this = TInitialized(_) and result = "Initialized"
        // TODO: add intermediate use
      }
    }

    class UninitializedFlowState extends InitFlowState, TUninitialized { }

    class InitializedFlowState extends InitFlowState, TInitialized {
      Init call;
      DataFlow::Node node1;
      DataFlow::Node node2;

      InitializedFlowState() {
        this = TInitialized(call) and
        node2.asExpr() = call.(MethodCall).getQualifier() and
        DataFlow::localFlowStep(node1, node2) and
        node1 != node2
      }

      Init getInitCall() { result = call }

      DataFlow::Node getFstNode() { result = node1 }

      DataFlow::Node getSndNode() { result = node2 }
    }

    class IntermediateUseState extends InitFlowState, TIntermediateUse {
      Use call;
      DataFlow::Node node1;
      DataFlow::Node node2;

      IntermediateUseState() {
        this = TIntermediateUse(call) and
        call.isIntermediate() and
        node1.asExpr() = call.(MethodCall).getQualifier() and
        node2 = node1
      }

      Use getUseCall() { result = call }

      DataFlow::Node getFstNode() { result = node1 }

      DataFlow::Node getSndNode() { result = node2 }
    }

    module GetInstanceToInitToUseConfig implements DataFlow::StateConfigSig {
      class FlowState = InitFlowState;

      predicate isSource(DataFlow::Node src, FlowState state) {
        state instanceof UninitializedFlowState and
        src.asExpr() instanceof GetInstance
        or
        src = state.(InitializedFlowState).getSndNode()
        or
        src = state.(IntermediateUseState).getSndNode()
      }

      // TODO: document this, but this is intentional (avoid cross products?)
      predicate isSink(DataFlow::Node sink, FlowState state) { none() }

      predicate isSink(DataFlow::Node sink) {
        exists(Init c | c.(MethodCall).getQualifier() = sink.asExpr())
        or
        exists(Use c | not c.isIntermediate() and c.(MethodCall).getQualifier() = sink.asExpr())
      }

      predicate isAdditionalFlowStep(
        DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
      ) {
        state1 = state1 and
        (
          node1 = state2.(InitializedFlowState).getFstNode() and
          node2 = state2.(InitializedFlowState).getSndNode()
          or
          node1 = state2.(IntermediateUseState).getFstNode() and
          node2 = state2.(IntermediateUseState).getSndNode()
        )
      }

      predicate isBarrier(DataFlow::Node node, FlowState state) {
        exists(CipherInitCall call | node.asExpr() = call.getQualifier() |
          state instanceof UninitializedFlowState
          or
          state.(InitializedFlowState).getInitCall() != call
        )
      }
    }

    module GetInstanceToInitToUseFlow = DataFlow::GlobalWithState<GetInstanceToInitToUseConfig>;

    GetInstance getInstantiationFromUse(
      Use use, GetInstanceToInitToUseFlow::PathNode src, GetInstanceToInitToUseFlow::PathNode sink
    ) {
      src.getNode().asExpr() = result and
      sink.getNode().asExpr() = use.(MethodCall).getQualifier() and
      GetInstanceToInitToUseFlow::flowPath(src, sink)
    }

    GetInstance getInstantiationFromInit(
      Init init, GetInstanceToInitToUseFlow::PathNode src, GetInstanceToInitToUseFlow::PathNode sink
    ) {
      src.getNode().asExpr() = result and
      sink.getNode().asExpr() = init.(MethodCall).getQualifier() and
      GetInstanceToInitToUseFlow::flowPath(src, sink)
    }

    Init getInitFromUse(
      Use use, GetInstanceToInitToUseFlow::PathNode src, GetInstanceToInitToUseFlow::PathNode sink
    ) {
      src.getNode().asExpr() = result.(MethodCall).getQualifier() and
      sink.getNode().asExpr() = use.(MethodCall).getQualifier() and
      GetInstanceToInitToUseFlow::flowPath(src, sink)
    }

    predicate hasInit(Use use) { exists(getInitFromUse(use, _, _)) }

    Use getAnIntermediateUseFromFinalUse(
      Use final, GetInstanceToInitToUseFlow::PathNode src, GetInstanceToInitToUseFlow::PathNode sink
    ) {
      not final.isIntermediate() and
      result.isIntermediate() and
      src.getNode().asExpr() = result.(MethodCall).getQualifier() and
      sink.getNode().asExpr() = final.(MethodCall).getQualifier() and
      GetInstanceToInitToUseFlow::flowPath(src, sink)
    }
  }

  module CipherFlowAnalysisImpl =
    GetInstanceInitUseFlowAnalysis<CipherGetInstanceCall, CipherInitCall, CipherOperationCall>;

  module CipherFlow = CipherFlowAnalysisImpl::GetInstanceToInitToUseFlow;

  Crypto::KeyOperationSubtype getKeyOperationSubtypeFromState(
    CipherFlowAnalysisImpl::InitFlowState state
  ) {
    state instanceof CipherFlowAnalysisImpl::UninitializedFlowState and
    result = Crypto::TUnknownKeyOperationMode()
    or
    exists(CipherInitCall call | state = CipherFlowAnalysisImpl::TInitialized(call) |
      result = call.getCipherOperationModeType()
    )
  }

  class CipherOperationInstance extends Crypto::KeyOperationInstance instanceof CipherOperationCall {
    override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
      if CipherFlowAnalysisImpl::hasInit(this)
      then result = CipherFlowAnalysisImpl::getInitFromUse(this, _, _).getCipherOperationModeType()
      else result = Crypto::TUnknownKeyOperationMode()
    }

    CipherGetInstanceCall getInstantiationCall() {
      result = CipherFlowAnalysisImpl::getInstantiationFromUse(this, _, _)
    }

    CipherInitCall getInitCall() { result = CipherFlowAnalysisImpl::getInitFromUse(this, _, _) }

    override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
      result.asExpr() = this.getInitCall().getNonceArg()
    }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      result = super.getMessageArg() or
      result = CipherFlowAnalysisImpl::getAnIntermediateUseFromFinalUse(this, _, _).getMessageArg()
    }

    override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
      result.asExpr() = this.getInitCall().getKeyArg()
    }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      result = this.getInstantiationCall().getAlgorithmArg()
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
      result.asExpr() = super.getOutput()
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
    string mode, Crypto::KeyOperationSubtype cipher_mode
  ) {
    mode = "ENCRYPT_MODE" and cipher_mode = Crypto::TEncryptMode()
    or
    mode = "WRAP_MODE" and cipher_mode = Crypto::TWrapMode()
    or
    mode = "DECRYPT_MODE" and cipher_mode = Crypto::TDecryptMode()
    or
    mode = "UNWRAP_MODE" and cipher_mode = Crypto::TUnwrapMode()
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

    Crypto::KeyOperationSubtype getCipherOperationModeType() {
      if cipher_mode_str_to_cipher_mode_known(this.getModeOrigin().getField().getName(), _)
      then cipher_mode_str_to_cipher_mode_known(this.getModeOrigin().getField().getName(), result)
      else result = Crypto::TUnknownKeyOperationMode()
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

  /*
   * Hash Functions
   */

  /**
   * Flow from a known hash algorithm name to a `MessageDigest.getInstance(sink)` call.
   */
  module KnownHashAlgorithmLiteralToMessageDigestConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { hash_names(src.asExpr().(StringLiteral).getValue()) }

    predicate isSink(DataFlow::Node sink) {
      exists(HashAlgorithmValueConsumer consumer | sink = consumer.getInputNode())
    }
  }

  module KnownHashAlgorithmLiteralToMessageDigestFlow =
    DataFlow::Global<KnownHashAlgorithmLiteralToMessageDigestConfig>;

  class KnownHashAlgorithm extends Crypto::HashAlgorithmInstance instanceof StringLiteral {
    HashAlgorithmValueConsumer consumer;

    KnownHashAlgorithm() {
      hash_names(this.getValue()) and
      KnownHashAlgorithmLiteralToMessageDigestFlow::flow(DataFlow::exprNode(this),
        consumer.getInputNode())
    }

    HashAlgorithmValueConsumer getConsumer() { result = consumer }

    override string getRawHashAlgorithmName() { result = this.(StringLiteral).getValue() }

    override Crypto::THashType getHashFamily() {
      result = hash_name_to_type_known(this.getRawHashAlgorithmName(), _)
    }

    override int getFixedDigestLength() {
      exists(hash_name_to_type_known(this.getRawHashAlgorithmName(), result))
    }
  }

  module MessageDigestFlowAnalysisImpl =
    GetInstanceInitUseFlowAnalysis<MessageDigestGetInstanceCall, DUMMY_UNUSED_METHODCALL, DigestCall>;

  class MessageDigestGetInstanceAlgorithmValueConsumer extends HashAlgorithmValueConsumer {
    MessageDigestGetInstanceCall call;

    MessageDigestGetInstanceAlgorithmValueConsumer() { this = call.getAlgorithmArg() }

    MessageDigestGetInstanceCall getInstantiationCall() { result = call }

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
  }

  class DigestCall extends MethodCall {
    DigestCall() {
      this.getCallee().hasQualifiedName("java.security", "MessageDigest", ["update", "digest"])
    }

    Expr getDigestArtifactOutput() { result = this }

    Expr getInputArg() { result = this.getArgument(0) }

    predicate isIntermediate() { this.getMethod().getName() = "update" }
  }

  // flow config from MessageDigest.getInstance to MessageDigest.digest
  module DigestGetInstanceToDigestConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof MessageDigestGetInstanceCall }

    predicate isSink(DataFlow::Node sink) {
      exists(DigestCall c | c.getQualifier() = sink.asExpr())
    }
  }

  module DigestGetInstanceToDigestFlow = DataFlow::Global<DigestGetInstanceToDigestConfig>;

  class DigestHashOperation extends Crypto::HashOperationInstance instanceof DigestCall {
    DigestHashOperation() { not super.isIntermediate() }

    override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
      result.asExpr() = super.getDigestArtifactOutput()
    }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      MessageDigestFlowAnalysisImpl::getInstantiationFromUse(this, _, _) =
        result.(MessageDigestGetInstanceAlgorithmValueConsumer).getInstantiationCall()
    }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      result.asExpr() = super.getInputArg() or
      result.asExpr() =
        MessageDigestFlowAnalysisImpl::getAnIntermediateUseFromFinalUse(this, _, _).getInputArg()
    }
  }

  /*
   * Key Generation
   */

  module KeyGeneratorFlowAnalysisImpl =
    GetInstanceInitUseFlowAnalysis<KeyGeneratorGetInstanceCall, KeyGeneratorInitCall,
      KeyGeneratorGenerateCall>;

  module KeyGeneratorFlow = KeyGeneratorFlowAnalysisImpl::GetInstanceToInitToUseFlow;

  abstract class KeyGeneratorParameterSpecClassInstanceExpr extends ClassInstanceExpr {
    KeyGeneratorInitCall getAnInitCallUse() {
      exists(DataFlow::Node sink |
        KeyGeneratorParameterSpecToInitializeFlow::flow(DataFlow::exprNode(this), sink) and
        result.getAlgorithmParameterSpecArg() = sink.asExpr()
      )
    }
  }

  class DHGenParameterSpecInstance extends KeyGeneratorParameterSpecClassInstanceExpr {
    DHGenParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("javax.crypto.spec", "DHGenParameterSpec")
    }

    Expr getPrimeSizeArg() { result = this.getArgument(0) }

    Expr getExponentSizeArg() { result = this.getArgument(1) }
  }

  class DSAParameterSpecInstance extends KeyGeneratorParameterSpecClassInstanceExpr {
    DSAParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("java.security.spec", "DSAParameterSpec")
    }

    Expr getPArg() { result = this.getArgument(0) }

    Expr getQArg() { result = this.getArgument(1) }

    Expr getSeedLenArg() { result = this.getArgument(2) }
  }

  class ECGenParameterSpecInstance extends KeyGeneratorParameterSpecClassInstanceExpr {
    ECGenParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("java.security.spec", "ECGenParameterSpec")
    }

    Expr getCurveNameArg() { result = this.getArgument(0) }

    Expr getRandomNumberGeneratorArg() { result = this.getArgument(1) }
  }

  class RSAGenParameterSpecInstance extends KeyGeneratorParameterSpecClassInstanceExpr {
    RSAGenParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("java.security.spec", "RSAGenParameterSpec")
    }

    Expr getKeySizeArg() { result = this.getArgument(0) }
  }

  private module KeyGeneratorParameterSpecToInitializeConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) {
      src.asExpr() instanceof KeyGeneratorParameterSpecClassInstanceExpr
    }

    predicate isSink(DataFlow::Node sink) {
      exists(KeyGeneratorInitCall c |
        c.getKeyType() = Crypto::TAsymmetricKeyType() and
        c.getArgument(0) = sink.asExpr()
      )
    }
  }

  module KeyGeneratorParameterSpecToInitializeFlow =
    DataFlow::Global<KeyGeneratorParameterSpecToInitializeConfig>;

  class ECGenParameterSpecClassInstanceExpr extends KeyGeneratorParameterSpecClassInstanceExpr {
    ECGenParameterSpecClassInstanceExpr() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("java.security.spec", "ECGenParameterSpec")
    }

    Expr getAlgorithmArg() { result = this.getArgument(0) }
  }

  class KeyGenerationAlgorithmValueConsumer extends CipherAlgorithmValueConsumer,
    KeyAgreementAlgorithmValueConsumer, EllipticCurveAlgorithmValueConsumer instanceof Expr
  {
    KeyGeneratorGetInstanceCall instantiationCall;

    KeyGenerationAlgorithmValueConsumer() {
      // This is only an algorithm value consumer if it accepts a spec rather than a key size (integral)
      this = instantiationCall.getAlgorithmArg() and not super.getType() instanceof IntegralType
      or
      // However, for general elliptic curves, getInstance("EC") is used
      // and java.security.spec.ECGenParameterSpec("<CURVE NAME>") is what sets the specific curve.
      // If init is not specified, the default (P-)
      // The result of ECGenParameterSpec is passed to KeyPairGenerator.initialize
      // If the curve is not specified, the default is used.
      // We would trace the use of this inside a KeyPairGenerator.initialize
      exists(KeyGeneratorInitCall initCall, ECGenParameterSpecClassInstanceExpr spec |
        KeyGeneratorFlow::flow(DataFlow::exprNode(instantiationCall),
          DataFlow::exprNode(initCall.getQualifier())) and
        spec.getAnInitCallUse() = initCall and
        spec.getAlgorithmArg() = this
      )
    }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
      result.(CipherStringLiteralAlgorithmInstance).getConsumer() = this or
      result.(KeyAgreementStringLiteralAlgorithmInstance).getConsumer() = this or
      result.(EllipticCurveStringLiteralInstance).getConsumer() = this
    }

    KeyGeneratorGetInstanceCall getInstantiationCall() { result = instantiationCall }
  }

  // TODO: Link getAlgorithm from KeyPairGenerator to algorithm instances or AVCs? High priority.
  class KeyGeneratorGetInstanceCall extends MethodCall {
    KeyGeneratorGetInstanceCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "KeyGenerator", "getInstance")
      or
      this.getCallee().hasQualifiedName("java.security", "KeyPairGenerator", "getInstance")
    }

    Expr getAlgorithmArg() { result = super.getArgument(0) }
  }

  class KeyGeneratorInitCall extends MethodCall {
    Crypto::TKeyArtifactType keyType;

    KeyGeneratorInitCall() {
      this.getCallee().hasQualifiedName("java.security", "KeyPairGenerator", "initialize") and
      keyType = Crypto::TAsymmetricKeyType()
      or
      this.getCallee().hasQualifiedName("javax.crypto", "KeyGenerator", ["init", "initialize"]) and
      keyType = Crypto::TSymmetricKeyType()
    }

    Crypto::TKeyArtifactType getKeyType() { result = keyType }

    Expr getAlgorithmParameterSpecArg() {
      result = this.getArgument(0) and
      this.getMethod().getParameterType(0).hasName("AlgorithmParameterSpec")
    }

    Expr getKeySizeArg() {
      result = this.getArgument(0) and
      this.getMethod().getParameterType(0) instanceof IntegralType
    }

    Expr getRandomnessSourceArg() {
      exists(int index |
        this.getMethod().getParameterType(index).hasName("SecureRandom") and
        result = this.getArgument(index)
      )
    }
  }

  class KeyGeneratorGenerateCall extends Crypto::KeyGenerationOperationInstance instanceof MethodCall
  {
    Crypto::KeyArtifactType type;

    KeyGeneratorGenerateCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "KeyGenerator", "generateKey") and
      type instanceof Crypto::TSymmetricKeyType
      or
      this.getCallee()
          .hasQualifiedName("java.security", "KeyPairGenerator", ["generateKeyPair", "genKeyPair"]) and
      type instanceof Crypto::TAsymmetricKeyType
    }

    predicate isIntermediate() { none() }

    override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() { result.asExpr() = this }

    override Crypto::KeyArtifactType getOutputKeyType() { result = type }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      KeyGeneratorFlowAnalysisImpl::getInstantiationFromUse(this, _, _) =
        result.(KeyGenerationAlgorithmValueConsumer).getInstantiationCall()
    }

    Crypto::AlgorithmInstance getAKnownAlgorithm() {
      result = this.getAnAlgorithmValueConsumer().getAKnownAlgorithmSource()
    }

    override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
      KeyGeneratorFlowAnalysisImpl::getInitFromUse(this, _, _).getKeySizeArg() = result.asExpr()
    }

    override string getKeySizeFixed() { none() }
  }

  class KeyGeneratorCipherAlgorithm extends CipherStringLiteralAlgorithmInstance {
    KeyGeneratorCipherAlgorithm() { consumer instanceof KeyGenerationAlgorithmValueConsumer }

    override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
      exists(KeyGeneratorGetInstanceCall getInstance, KeyGeneratorInitCall init |
        getInstance =
          this.getConsumer().(KeyGenerationAlgorithmValueConsumer).getInstantiationCall() and
        getInstance = KeyGeneratorFlowAnalysisImpl::getInstantiationFromInit(init, _, _) and
        init.getKeySizeArg() = result.asExpr()
      )
    }

    predicate isOnlyConsumedByKeyGen() {
      forall(Crypto::AlgorithmValueConsumer c |
        c = this.getConsumer() and
        c instanceof KeyGenerationAlgorithmValueConsumer
      )
    }

    override predicate shouldHaveModeOfOperation() { this.isOnlyConsumedByKeyGen() }

    override predicate shouldHavePaddingScheme() { this.isOnlyConsumedByKeyGen() }
  }

  /*
   * Key Derivation Functions (KDFs)
   */

  class KeySpecInstantiation extends ClassInstanceExpr {
    KeySpecInstantiation() {
      this.getConstructedType()
          .hasQualifiedName("javax.crypto.spec",
            ["PBEKeySpec", "SecretKeySpec", "PBEKeySpec", "DESedeKeySpec"])
    }

    Expr getPasswordArg() { result = this.getArgument(0) }
  }

  class PBEKeySpecInstantiation extends KeySpecInstantiation {
    PBEKeySpecInstantiation() { this.getConstructedType().hasName("PBEKeySpec") }

    Expr getSaltArg() { result = this.getArgument(1) }

    Expr getIterationCountArg() { result = this.getArgument(2) }

    Expr getKeyLengthArg() { result = this.getArgument(3) }
  }

  module KeySpecInstantiationToGenerateSecretFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) {
      exists(KeySpecInstantiation call | src.asExpr() = call)
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

  module KeySpecInstantiationToGenerateSecretFlow =
    DataFlow::Global<KeySpecInstantiationToGenerateSecretFlowConfig>;

  module KDFAlgorithmStringToGetInstanceFlow =
    DataFlow::Global<KDFAlgorithmStringToGetInstanceConfig>;

  class DUMMY_UNUSED_METHODCALL extends MethodCall {
    DUMMY_UNUSED_METHODCALL() { none() }
  }

  module SecretKeyFactoryFlowAnalysisImpl =
    GetInstanceInitUseFlowAnalysis<SecretKeyFactoryGetInstanceCall, DUMMY_UNUSED_METHODCALL,
      SecretKeyFactoryGenerateSecretCall>;

  module SecretKeyFactoryFlow = SecretKeyFactoryFlowAnalysisImpl::GetInstanceToInitToUseFlow;

  class SecretKeyFactoryGetInstanceCall extends MethodCall {
    SecretKeyFactoryGetInstanceCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "SecretKeyFactory", "getInstance")
    }

    Expr getAlgorithmArg() { result = this.getArgument(0) }
  }

  class SecretKeyFactoryGenerateSecretCall extends MethodCall {
    SecretKeyFactoryGenerateSecretCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "SecretKeyFactory", "generateSecret")
    }

    Expr getKeySpecArg() { result = this.getArgument(0) }

    predicate isIntermediate() { none() }
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
      result = hash_name_to_type_known(this.getRawHashAlgorithmName(), _)
    }

    override int getFixedDigestLength() {
      exists(hash_name_to_type_known(this.getRawHashAlgorithmName(), result))
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

  class KeyDerivationOperationCall extends Crypto::KeyDerivationOperationInstance instanceof SecretKeyFactoryGenerateSecretCall
  {
    KeyDerivationOperationCall() { not super.isIntermediate() }

    KeySpecInstantiation getKeySpecInstantiation() {
      KeySpecInstantiationToGenerateSecretFlow::flow(DataFlow::exprNode(result),
        DataFlow::exprNode(super.getKeySpecArg()))
    }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      result.(SecretKeyFactoryKDFAlgorithmValueConsumer).getInstantiation() =
        SecretKeyFactoryFlowAnalysisImpl::getInstantiationFromUse(this, _, _)
    }

    override Crypto::ConsumerInputDataFlowNode getSaltConsumer() {
      result.asExpr() = this.getKeySpecInstantiation().(PBEKeySpecInstantiation).getSaltArg()
    }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      result.asExpr() = this.getKeySpecInstantiation().getPasswordArg()
    }

    override Crypto::ConsumerInputDataFlowNode getIterationCountConsumer() {
      result.asExpr() =
        this.getKeySpecInstantiation().(PBEKeySpecInstantiation).getIterationCountArg()
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() { result.asExpr() = this }

    override Crypto::ConsumerInputDataFlowNode getOutputKeySizeConsumer() {
      result.asExpr() = this.getKeySpecInstantiation().(PBEKeySpecInstantiation).getKeyLengthArg()
    }

    override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
      result.asExpr() = this.getKeySpecInstantiation().(PBEKeySpecInstantiation).getKeyLengthArg()
    }

    override string getKeySizeFixed() { none() }

    override string getOutputKeySizeFixed() { none() }

    override string getIterationCountFixed() { none() }
  }

  /*
   * Key agreement
   */

  module KeyAgreementFlowAnalysisImpl =
    GetInstanceInitUseFlowAnalysis<KeyAgreementGetInstanceCall, KeyAgreementInitCall,
      KeyAgreementCall>;

  class KeyAgreementStringLiteral extends StringLiteral {
    KeyAgreementStringLiteral() { key_agreement_names(this.getValue()) }
  }

  /**
   * Data-flow configuration modelling flow from a key agreement string literal to a key agreement algorithm consumer.
   */
  private module KeyAgreementAlgorithmStringToConsumerConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof KeyAgreementStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      sink = any(KeyAgreementAlgorithmValueConsumer consumer).getInputNode()
    }
  }

  module KeyAgreementAlgorithmStringToConsumerFlow =
    TaintTracking::Global<KeyAgreementAlgorithmStringToConsumerConfig>;

  class KeyAgreementInitCall extends MethodCall {
    KeyAgreementInitCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "KeyAgreement", "init")
    }

    Expr getServerKeyArg() { result = this.getArgument(0) }
  }

  class KeyAgreementGetInstanceCall extends MethodCall {
    KeyAgreementGetInstanceCall() {
      this.getCallee().hasQualifiedName("javax.crypto", "KeyAgreement", "getInstance")
    }

    Expr getAlgorithmArg() { result = super.getArgument(0) }
  }

  private class KeyAgreementGetInstanceAlgorithmArgValueConsumer extends KeyAgreementAlgorithmValueConsumer
  {
    KeyAgreementGetInstanceCall call;

    KeyAgreementGetInstanceAlgorithmArgValueConsumer() { this = call.getAlgorithmArg() }

    override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
      result.(KeyAgreementStringLiteralAlgorithmInstance).getConsumer() = this
    }

    KeyAgreementGetInstanceCall getInstantiationCall() { result = call }
  }

  class KeyAgreementStringLiteralAlgorithmInstance extends Crypto::KeyAgreementAlgorithmInstance instanceof KeyAgreementStringLiteral
  {
    KeyAgreementAlgorithmValueConsumer consumer;

    KeyAgreementStringLiteralAlgorithmInstance() {
      KeyAgreementAlgorithmStringToConsumerFlow::flow(DataFlow::exprNode(this),
        consumer.getInputNode())
    }

    override string getRawKeyAgreementAlgorithmName() { result = super.getValue() }

    override Crypto::TKeyAgreementType getKeyAgreementType() {
      if key_agreement_name_to_type_known(_, super.getValue())
      then key_agreement_name_to_type_known(result, super.getValue())
      else result = Crypto::UnknownKeyAgreementType()
    }

    KeyAgreementAlgorithmValueConsumer getConsumer() { result = consumer }
  }

  class KeyAgreementCall extends MethodCall {
    KeyAgreementCall() {
      this.getCallee()
          .hasQualifiedName("javax.crypto", "KeyAgreement", ["generateSecret", "doPhase"])
    }

    predicate isIntermediate() { this.getCallee().getName() = "doPhase" }

    DataFlow::Node getOutputNode() {
      result.asExpr() = this and
      not this.isIntermediate()
    }

    Expr getPeerKeyArg() {
      this.isIntermediate() and
      result = this.getArgument(0) and
      this.getCallee().getName() = "doPhase"
    }
  }

  class KeyAgreementSecretGenerationOperationInstance extends Crypto::KeyAgreementSecretGenerationOperationInstance instanceof KeyAgreementCall
  {
    KeyAgreementSecretGenerationOperationInstance() {
      // exclude doPhase (only include generateSecret)
      not super.isIntermediate()
    }

    override Crypto::ConsumerInputDataFlowNode getServerKeyConsumer() {
      result.asExpr() = KeyAgreementFlowAnalysisImpl::getInitFromUse(this, _, _).getServerKeyArg()
    }

    override Crypto::ConsumerInputDataFlowNode getPeerKeyConsumer() {
      result.asExpr() =
        KeyAgreementFlowAnalysisImpl::getAnIntermediateUseFromFinalUse(this, _, _).getPeerKeyArg()
    }

    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      result.(KeyAgreementGetInstanceAlgorithmArgValueConsumer).getInstantiationCall() =
        KeyAgreementFlowAnalysisImpl::getInstantiationFromUse(this, _, _)
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { result.asExpr() = this }
  }

  /*
   * MACs
   */

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

  /*
   * Elliptic Curves (EC)
   */

  module EllipticCurveStringToConsumerConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof EllipticCurveStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      exists(EllipticCurveAlgorithmValueConsumer consumer | sink = consumer.getInputNode())
    }
  }

  module EllipticCurveStringToConsumerFlow = DataFlow::Global<EllipticCurveStringToConsumerConfig>;

  class EllipticCurveStringLiteral extends StringLiteral {
    EllipticCurveStringLiteral() { elliptic_curve_names(this.getValue()) }
  }

  class EllipticCurveStringLiteralInstance extends Crypto::EllipticCurveInstance instanceof EllipticCurveStringLiteral
  {
    EllipticCurveAlgorithmValueConsumer consumer;

    EllipticCurveStringLiteralInstance() {
      EllipticCurveStringToConsumerFlow::flow(DataFlow::exprNode(this), consumer.getInputNode())
    }

    override string getRawEllipticCurveName() { result = super.getValue() }

    override Crypto::TEllipticCurveType getEllipticCurveType() {
      if Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), _, _)
      then
        Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), _, result)
      else result = Crypto::OtherEllipticCurveType()
    }

    override string getKeySize() {
      exists(int keySize |
        Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), keySize,
          _)
      |
        result = keySize.toString()
      )
    }

    EllipticCurveAlgorithmValueConsumer getConsumer() { result = consumer }
  }
}
