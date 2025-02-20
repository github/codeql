import java
import semmle.code.java.dataflow.DataFlow

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

  class CipherDoFinalCall extends Call {
    CipherDoFinalCall() { this.getCallee().hasQualifiedName("javax.crypto", "Cipher", "doFinal") }
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
  class CipherGetInstanceAlgorithmArg extends Crypto::EncryptionAlgorithmInstance,
    Crypto::ModeOfOperationAlgorithmInstance, Crypto::PaddingAlgorithmInstance instanceof Expr
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

  // TODO: what if encrypt/decrypt mode isn't known
  private module CipherGetInstanceToFinalizeConfig implements DataFlow::StateConfigSig {
    class FlowState = Crypto::TCipherOperationMode;

    predicate isSource(DataFlow::Node src, FlowState state) {
      state = Crypto::UnknownCipherOperationMode() and
      src.asExpr() instanceof CipherGetInstanceCall
    }

    predicate isSink(DataFlow::Node sink, FlowState state) {
      exists(CipherDoFinalCall c | c.getQualifier() = sink.asExpr())
    }

    predicate isAdditionalFlowStep(
      DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
    ) {
      exists(CipherInitCall c |
        c.getQualifier() = node1.asExpr() and
        // TODO: not taking into consideration if the mode traces to this arg
        exists(FieldAccess fa |
          c.getModeArg() = fa and
          (
            if fa.getField().getName() in ["ENCRYPT_MODE", "WRAP_MODE"]
            then state2 = Crypto::EncryptionMode()
            else (
              if fa.getField().getName() in ["DECRYPT_MODE", "UNWRAP_MODE"]
              then state2 = Crypto::DecryptionMode()
              else state2 = Crypto::UnknownCipherOperationMode()
            )
          )
        )
      ) and
      node2 = node1
    }
  }

  module CipherGetInstanceToFinalizeFlow =
    DataFlow::GlobalWithState<CipherGetInstanceToFinalizeConfig>;

  class CipherEncryptionOperation extends Crypto::CipherOperationInstance instanceof Call {
    Crypto::TCipherOperationMode mode;
    Crypto::EncryptionAlgorithmInstance algorithm;

    CipherEncryptionOperation() {
      exists(
        CipherGetInstanceToFinalizeFlow::PathNode sink,
        CipherGetInstanceToFinalizeFlow::PathNode src, CipherGetInstanceCall getCipher,
        CipherDoFinalCall doFinalize, CipherGetInstanceAlgorithmArg arg
      |
        CipherGetInstanceToFinalizeFlow::flowPath(src, sink) and
        src.getNode().asExpr() = getCipher and
        sink.getNode().asExpr() = doFinalize.getQualifier() and
        sink.getState() = mode and
        this = doFinalize and
        arg.getCall() = getCipher and 
        algorithm = arg
      )
    }

    override Crypto::EncryptionAlgorithmInstance getAlgorithm() { result = algorithm }

    override Crypto::TCipherOperationMode getCipherOperationMode() { result = mode }
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
      this = Crypto::TModeOfOperationAlgorithm(instance) and
      // TODO: this currently only holds for explicitly defined modes in a string literal.
      // Cases with defaults, e.g., "AES", are not yet modelled.
      // For these cases, in a CBOM, the AES node would have an unknown edge to its mode child.
      exists(instance.getOrigin().getMode())
    }

    override Location getLocation() { result = instance.getLocation() }

    // In this case, the raw name is still only the /MODE/ part.
    // TODO: handle defaults
    override string getRawAlgorithmName() { result = instance.getOrigin().getMode() }

    private predicate modeToNameMappingKnown(Crypto::TModeOperationType type, string name) {
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

    override Crypto::TModeOperationType getModeType() {
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

  class EncryptionAlgorithm extends Crypto::EncryptionAlgorithm {
    CipherStringLiteral origin;
    CipherGetInstanceAlgorithmArg instance;

    EncryptionAlgorithm() {
      this = Crypto::TEncryptionAlgorithm(instance) and
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
      else result instanceof Crypto::OtherSymmetricCipherType
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
   * Initialiation vectors
   */
  abstract class IVParameterInstantiation extends Crypto::InitializationVectorArtifactInstance instanceof ClassInstanceExpr
  {
    abstract Expr getInput();
  }

  class IvParameterSpecInstance extends IVParameterInstantiation {
    IvParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("javax.crypto.spec", "IvParameterSpec")
    }

    override Expr getInput() { result = this.(ClassInstanceExpr).getArgument(0) }
  }

  class GCMParameterSpecInstance extends IVParameterInstantiation {
    GCMParameterSpecInstance() {
      this.(ClassInstanceExpr)
          .getConstructedType()
          .hasQualifiedName("javax.crypto.spec", "GCMParameterSpec")
    }

    override Expr getInput() { result = this.(ClassInstanceExpr).getArgument(1) }
  }

  class CipherInitCall extends MethodCall {
    CipherInitCall() { this.getCallee().hasQualifiedName("javax.crypto", "Cipher", "init") }

    // TODO: this doesn't account for tracing the mode to this arg if expending this arg to have
    // the actual mode directly
    Expr getModeArg() { result = this.getArgument(0) }

    // TODO: need a getModeOrigin

    Expr getKey() {
      result = this.getArgument(1) and this.getMethod().getParameterType(1).hasName("Key")
    }

    Expr getIV() {
      result = this.getArgument(2) and
      this.getMethod().getParameterType(2).hasName("AlgorithmParameterSpec")
    }
  }

  // TODO: cipher.getParameters().getParameterSpec(GCMParameterSpec.class);
  /*
   *  class InitializationVectorArg extends Crypto::InitializationVectorArtifactInstance instanceof Expr
   *  {
   *    IVParameterInstantiation creation;
   *
   *    InitializationVectorArg() { this = creation.getInput() }
   *  }
   */

  class InitializationVector extends Crypto::InitializationVector {
    IVParameterInstantiation instance;

    InitializationVector() { this = Crypto::TInitializationVector(instance) }

    override Location getLocation() { result = instance.getLocation() }

    override Crypto::DataFlowNode asOutputData() { result.asExpr() = instance }

    override Crypto::DataFlowNode getInputData() { result.asExpr() = instance.getInput() }
  }
}
