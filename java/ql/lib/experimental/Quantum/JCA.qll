import java
import semmle.code.java.dataflow.DataFlow

module JCAModel {
  import Language

  abstract class EncryptionOperation extends Crypto::EncryptionOperation { }

  //TODO PBEWith can have suffixes. how to do? enumerate? or match a pattern?
  predicate cipher_names(string algo) {
    algo =
      [
        "AES", "AESWrap", "AESWrapPad", "ARCFOUR", "Blowfish", "ChaCha20", "ChaCha20-Poly1305",
        "DES", "DESede", "DESedeWrap", "ECIES", "PBEWith", "RC2", "RC4", "RC5", "RSA"
      ]
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

  ////cipher specifics ----------------------------------------
  class CipherInstance extends Call {
    CipherInstance() { this.getCallee().hasQualifiedName("javax.crypto", "Cipher", "getInstance") }

    Expr getAlgorithmArg() { result = this.getArgument(0) }
  }

  /**
   * this may be specified either in the ALG/MODE/PADDING or just ALG format
   */
  class CipherAlgorithmStringLiteral extends StringLiteral {
    CipherAlgorithmStringLiteral() { cipher_names(this.getValue().splitAt("/")) }
  }

  class ModeOfOperationStringLiteral extends StringLiteral {
    ModeOfOperationStringLiteral() { cipher_modes(this.(StringLiteral).getValue().splitAt("/")) }

    string getRawAlgorithmName() { result = this.getValue().regexpCapture(".*/(.*)/.*", 1) }
  }

  class ECBMode extends Crypto::ModeOfOperation {
    ModeOfOperationStringLiteral mode;

    ECBMode() { modeStringToCipherInstanceArgFlow("ECB", mode, this) }

    override string getRawAlgorithmName() { result = mode.getRawAlgorithmName() }

    predicate modeToNameMapping(Crypto::TModeOperation type, string name) {
      name = "ECB" and type instanceof Crypto::ECB
    }

    override Crypto::TModeOperation getModeType() {
      modeToNameMapping(result, this.getRawAlgorithmName())
    }

    override Crypto::LocatableElement getOrigin(string name) {
      result = mode and name = mode.toString()
    }
  }

  abstract class CipherAlgorithmPadding extends Crypto::NodeBase {
    string getValue() { result = "" }
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
  private module AlgorithmStringToFetchConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CipherAlgorithmStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      exists(CipherInstance call | sink.asExpr() = call.getAlgorithmArg())
    }
  }

  module AlgorithmStringToFetchFlow = DataFlow::Global<AlgorithmStringToFetchConfig>;

  predicate algorithmStringToCipherInstanceArgFlow(
    string name, CipherAlgorithmStringLiteral origin, Expr arg
  ) {
    exists(CipherInstance sinkCall |
      origin.getValue().splitAt("/") = name and
      arg = sinkCall and
      AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(origin),
        DataFlow::exprNode(sinkCall.getAlgorithmArg()))
    )
  }

  predicate modeStringToCipherInstanceArgFlow(
    string name, ModeOfOperationStringLiteral mode, Expr arg
  ) {
    exists(CipherInstance sinkCall |
      //consider if this should be a more specific predicate
      mode.getRawAlgorithmName() = name and
      arg = sinkCall and
      AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(mode),
        DataFlow::exprNode(sinkCall.getAlgorithmArg()))
    )
  }

  /**
   * A class to represent when AES is used
   * AND currently it has literal mode and padding provided
   *
   * this currently does not capture the use without a literal
   * though should be extended to
   */
  class AESAlgo extends Crypto::SymmetricAlgorithm instanceof Expr {
    CipherAlgorithmStringLiteral alg;

    AESAlgo() { algorithmStringToCipherInstanceArgFlow("AES", alg, this) }

    //todo this is really not correct yet
    override Crypto::ModeOfOperation getModeOfOperation() {
      none()
      //exists(Crypto::ModeOfOperation mode | mode = this and result = this)
    }

    override Crypto::LocatableElement getOrigin(string name) {
      result = alg and name = alg.toString()
    }

    override string getAlgorithmName() { result = "AES" }

    override string getRawAlgorithmName() { result = alg.getValue() }

    override Crypto::TSymmetricCipherFamilyType getSymmetricCipherFamilyType() {
      result instanceof Crypto::AES
    }

    //temp hacks for testing
    override string getKeySize(Location location) { result = "" }

    override Crypto::TCipherStructure getCipherType() { none() }
  }
}
