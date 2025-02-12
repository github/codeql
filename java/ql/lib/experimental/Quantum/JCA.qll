import java
import semmle.code.java.dataflow.DataFlow

module JCAModel {
  import Language

  abstract class EncryptionOperation extends Crypto::EncryptionOperation { }

  //TODO PBEWith can have suffixes. how to do? enumerate? or match a pattern?
  bindingset[algo]
  predicate cipher_names(string algo) {
    // "Standard names are not case-sensitive."
    algo.toUpperCase()
        .matches([
            "AES", "AESWrap", "AESWrapPad", "ARCFOUR", "Blowfish", "ChaCha20", "ChaCha20-Poly1305",
            "DES", "DESede", "DESedeWrap", "ECIES", "PBEWith%", "RC2", "RC4", "RC5", "RSA"
          ].toUpperCase())
  }

  //TODO solve the fact that x is an int of various values. same as above... enumerate?
  predicate cipher_modes(string mode) {
    mode =
      [
        "NONE", "CBC", "CCM", "CFB", "CFBx", "CTR", "CTS", "ECB", "GCM", "KW", "KWP", "OFB", "OFBx",
        "PCBC"
      ]
  }

  //todo same as above, OAEPWith has asuffix type
  predicate cipher_padding(string padding) {
    padding =
      [
        "NoPadding", "ISO10126Padding", "OAEPPadding", "OAEPWith", "PKCS1Padding", "PKCS5Padding",
        "SSL3Padding"
      ]
  }

  /**
   * this may be specified either in the ALG/MODE/PADDING or just ALG format
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
  }

  private module AlgorithmStringToFetchConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CipherStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      exists(CipherGetInstanceCall call | sink.asExpr() = call.getAlgorithmArg())
    }
  }

  module AlgorithmStringToFetchFlow = DataFlow::Global<AlgorithmStringToFetchConfig>;

  class CipherGetInstanceAlgorithmArg extends Expr {
    CipherGetInstanceAlgorithmArg() {
      exists(CipherGetInstanceCall call | this = call.getArgument(0))
    }

    StringLiteral getOrigin() {
      AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(result), DataFlow::exprNode(this))
    }
  }

  class ModeStringLiteral extends Crypto::ModeOfOperation {
    CipherStringLiteral instance;

    ModeStringLiteral() {
      this = Crypto::TModeOfOperationAlgorithm(instance) and
      exists(instance.getMode()) and
      instance = any(CipherGetInstanceAlgorithmArg call).getOrigin()
    }

    override Location getLocation() { result = instance.getLocation() }

    override string getRawAlgorithmName() { result = instance.getMode() }

    predicate modeToNameMapping(Crypto::TModeOperationType type, string name) {
      super.modeToNameMapping(type, name)
    }

    override Crypto::TModeOperationType getModeType() {
      this.modeToNameMapping(result, instance.getMode().toUpperCase())
    }

    CipherStringLiteral getInstance() { result = instance }
  }

  //todo refactor
  // class CipherAlgorithmPaddingStringLiteral extends CipherAlgorithmPadding instanceof StringLiteral {
  //   CipherAlgorithmPaddingStringLiteral() {
  //     cipher_padding(this.(StringLiteral).getValue().splitAt("/"))
  //   }
  //   override string toString() { result = this.(StringLiteral).toString() }
  //   override string getValue() {
  //     result = this.(StringLiteral).getValue().regexpCapture(".*/.*/(.*)", 1)
  //   }
  // }
  /**
   * A class to represent when AES is used
   * AND currently it has literal mode and padding provided
   *
   * this currently does not capture the use without a literal
   * though should be extended to
   */
  class CipherAlgorithm extends Crypto::SymmetricAlgorithm {
    CipherStringLiteral origin;
    CipherGetInstanceAlgorithmArg instance;

    CipherAlgorithm() {
      this = Crypto::TSymmetricAlgorithm(instance) and
      instance.getOrigin() = origin
    }

    override Location getLocation() { result = instance.getLocation() }

    override Crypto::ModeOfOperation getModeOfOperation() {
      result.(ModeStringLiteral).getInstance() = origin
    }

    override Crypto::LocatableElement getOrigin(string name) {
      result = origin and name = origin.toString()
    }

    override string getRawAlgorithmName() { result = origin.getValue() }

    override Crypto::TSymmetricCipherType getCipherFamily() {
      this.cipherNameMapping(result, origin.getAlgorithmName())
    }

    override string getKeySize(Location location) { none() }

    bindingset[name]
    private predicate cipherNameMappingKnown(Crypto::TSymmetricCipherType type, string name) {
      name = "AES" and
      type instanceof Crypto::AES
      or
      name = "RC4" and
      type instanceof Crypto::RC4
    }

    bindingset[name]
    predicate cipherNameMapping(Crypto::TSymmetricCipherType type, string name) {
      this.cipherNameMappingKnown(type, name)
      or
      not this.cipherNameMappingKnown(_, name) and
      type instanceof Crypto::OtherSymmetricCipherType
    }
  }
}
