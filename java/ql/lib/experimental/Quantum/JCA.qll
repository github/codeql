import java
import semmle.code.java.dataflow.DataFlow

module JCAModel {
  import Language

  abstract class EncryptionOperation extends Crypto::EncryptionOperation { }

  //TODO PBEWith can have suffixes. how to do? enumerate? or match a pattern?
predicate cipher_names(string algo) { algo = ["AES", "AESWrap", "AESWrapPad", "ARCFOUR", "Blowfish", "ChaCha20", "ChaCha20-Poly1305", "DES", "DESede", "DESedeWrap", "ECIES", "PBEWith", "RC2", "RC4", "RC5", "RSA"] }
//TODO solve the fact that x is an int of various values. same as above... enumerate?
predicate cipher_modes(string mode) {mode = ["NONE", "CBC", "CCM", "CFB", "CFBx", "CTR", "CTS", "ECB", "GCM", "KW", "KWP", "OFB", "OFBx", "PCBC"]}
//todo same as above, OAEPWith has asuffix type
predicate cipher_padding(string padding) {padding = ["NoPadding", "ISO10126Padding", "OAEPPadding", "OAEPWith", "PKCS1Padding", "PKCS5Padding", "SSL3Padding"]}


abstract class BlockCiper extends Crypto::Algorithm {
  CipherAlgorithmStringLiteral alg;
  CipherAlgorithmMode mode;
  CipherAlgorithmPadding padding;


  CipherAlgorithmStringLiteral getAlg() {result = alg } 
  CipherAlgorithmMode getMode() {result = mode }

  CipherAlgorithmPadding getPadding() {result =padding}
}
  /**
   * Symmetric algorithms
   */
  abstract class SymmetricAlgorithm extends Crypto::Algorithm {


    //TODO figure out how to get this from the Cipher interface, is it explicit?
    //abstract string getKeySize(Location location);

    // override predicate properties(string key, string value, Location location) {
    //   super.properties(key, value, location)
    //   or
    //   key = "key_size" and
    //   if exists(this.getKeySize(location))
    //   then value = this.getKeySize(location)
    //   else (
    //     value instanceof Crypto::UnknownPropertyValue and location instanceof UnknownLocation
    //   )
    //   // other properties, like field type are possible, but not modeled until considered necessary
    // }

    abstract override string getAlgorithmName();
}

////cipher specifics ----------------------------------------

class CipherInstance extends Call {
    CipherInstance() { this.getCallee().hasQualifiedName("javax.crypto","Cipher", "getInstance") }

    Expr getAlgorithmArg() { result = this.getArgument(0) }
  }

  /**
   * this may be specified either in the ALG/MODE/PADDING or just ALG format
   */
class CipherAlgorithmStringLiteral extends Crypto::NodeBase instanceof StringLiteral {
    CipherAlgorithmStringLiteral() { cipher_names(this.getValue().splitAt("/"))}

    override string toString() { result = this.(StringLiteral).toString() }

    string getValue() { result = this.(StringLiteral).getValue() }
  }

abstract class CipherAlgorithmMode extends Crypto::NodeBase {
  string getValue() {result = ""}
}

  class CipherAlgorithmModeStringLiteral extends CipherAlgorithmMode instanceof StringLiteral {
    CipherAlgorithmModeStringLiteral() { cipher_modes(this.(StringLiteral).getValue().splitAt("/"))}

    override string toString() { result = this.(StringLiteral).toString() }

    override string getValue() { result = this.(StringLiteral).getValue().regexpCapture(".*/(.*)/.*",1) }
  }

  abstract class CipherAlgorithmPadding extends Crypto::NodeBase {
    string getValue() {result = ""}
  }

  class CipherAlgorithmPaddingStringLiteral extends CipherAlgorithmPadding instanceof StringLiteral {
    CipherAlgorithmPaddingStringLiteral() { cipher_padding(this.(StringLiteral).getValue().splitAt("/"))}

    override string toString() { result = this.(StringLiteral).toString() }

    override string getValue() { result = this.(StringLiteral).getValue().regexpCapture(".*/.*/(.*)",1) }
  }

  private module AlgorithmStringToFetchConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CipherAlgorithmStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      exists(CipherInstance call | sink.asExpr() = call.getAlgorithmArg())
    }
  }

  module AlgorithmStringToFetchFlow = DataFlow::Global<AlgorithmStringToFetchConfig>;

  predicate algorithmStringToCipherInstanceArgFlow(string name, CipherAlgorithmStringLiteral origin, CipherAlgorithmModeStringLiteral mode, CipherAlgorithmPaddingStringLiteral padding, Expr arg) {
    exists(CipherInstance sinkCall |
      origin.getValue().splitAt("/") = name and
     origin = mode and
      origin = padding and
      arg = sinkCall.getAlgorithmArg() and
      AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(origin), DataFlow::exprNode(arg))
    )
  }

  /**
   * A class to represent when AES is used AND it has literal mode and padding provided
   * this does not capture the use without
   */
  class AESLiteral extends SymmetricAlgorithm, BlockCiper instanceof Expr {


    AESLiteral() { algorithmStringToCipherInstanceArgFlow("AES", alg, mode, padding, this) 
}

    override Crypto::LocatableElement getOrigin(string name) {
      result = alg and name = alg.toString()
    }

    override string getAlgorithmName(){ result = alg.getValue()}
  }

  
}