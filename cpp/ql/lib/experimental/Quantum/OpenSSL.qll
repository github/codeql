import cpp
import semmle.code.cpp.dataflow.new.DataFlow

module OpenSSLModel {
  import Language

  abstract class KeyDerivationOperation extends Crypto::KeyDerivationOperation { }

  class SHA1Algo extends Crypto::HashAlgorithm instanceof MacroAccess {
    SHA1Algo() { this.getMacro().getName() = "SN_sha1" }

    override string getRawAlgorithmName() { result = "SN_sha1" }

    override Crypto::THashType getHashType() { result instanceof Crypto::SHA1 }
  }

  module AlgorithmToEVPKeyDeriveConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source.asExpr() instanceof KeyDerivationAlgorithm }

    predicate isSink(DataFlow::Node sink) {
      exists(EVP_KDF_derive kdo | sink.asExpr() = kdo.getAlgorithmArg())
    }
  }

  module AlgorithmToEVPKeyDeriveFlow = DataFlow::Global<AlgorithmToEVPKeyDeriveConfig>;

  predicate algorithm_to_EVP_KDF_derive(Crypto::Algorithm algo, EVP_KDF_derive derive) {
    algo.(Expr).getEnclosingFunction() = derive.(Expr).getEnclosingFunction()
  }

  class EVP_KDF_derive extends KeyDerivationOperation instanceof FunctionCall {
    EVP_KDF_derive() { this.getTarget().getName() = "EVP_KDF_derive" }

    override Crypto::Algorithm getAlgorithm() { algorithm_to_EVP_KDF_derive(result, this) }

    Expr getAlgorithmArg() { result = this.(FunctionCall).getArgument(3) }
  }

  abstract class KeyDerivationAlgorithm extends Crypto::KeyDerivationAlgorithm { }

  class EVP_KDF_fetch_Call extends FunctionCall {
    EVP_KDF_fetch_Call() { this.getTarget().getName() = "EVP_KDF_fetch" }

    Expr getAlgorithmArg() { result = this.getArgument(1) }
  }

  predicate kdf_names(string algo) { algo = ["HKDF", "PKCS12KDF"] }

  class KDFAlgorithmStringLiteral extends Crypto::NodeBase instanceof StringLiteral {
    KDFAlgorithmStringLiteral() { kdf_names(this.getValue().toUpperCase()) }

    override string toString() { result = this.(StringLiteral).toString() }

    string getValue() { result = this.(StringLiteral).getValue() }
  }

  private module AlgorithmStringToFetchConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof KDFAlgorithmStringLiteral }

    predicate isSink(DataFlow::Node sink) {
      exists(EVP_KDF_fetch_Call call | sink.asExpr() = call.getAlgorithmArg())
    }
  }

  module AlgorithmStringToFetchFlow = DataFlow::Global<AlgorithmStringToFetchConfig>;

  predicate algorithmStringToKDFFetchArgFlow(string name, KDFAlgorithmStringLiteral origin, Expr arg) {
    exists(EVP_KDF_fetch_Call sinkCall |
      origin.getValue().toUpperCase() = name and
      arg = sinkCall.getAlgorithmArg() and
      AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(origin), DataFlow::exprNode(arg))
    )
  }

  class HKDF extends KeyDerivationAlgorithm, Crypto::HKDF instanceof Expr {
    KDFAlgorithmStringLiteral origin;

    HKDF() { algorithmStringToKDFFetchArgFlow("HKDF", origin, this) }

    override Crypto::HashAlgorithm getHashAlgorithm() { none() }

    override Crypto::LocatableElement getOrigin(string name) {
      result = origin and name = origin.toString()
    }
  }

  class TestKeyDerivationOperationHacky extends KeyDerivationOperation instanceof FunctionCall {
    HKDF hkdf;

    TestKeyDerivationOperationHacky() {
      this.getEnclosingFunction() = hkdf.(Expr).getEnclosingFunction()
    }

    override Crypto::KeyDerivationAlgorithm getAlgorithm() { result = hkdf }
  }

  class PKCS12KDF extends KeyDerivationAlgorithm, Crypto::PKCS12KDF instanceof Expr {
    KDFAlgorithmStringLiteral origin;

    PKCS12KDF() { algorithmStringToKDFFetchArgFlow("PKCS12KDF", origin, this) }

    override Crypto::HashAlgorithm getHashAlgorithm() { none() }

    override Crypto::NodeBase getOrigin(string name) {
      result = origin and name = origin.toString()
    }
  }
}
