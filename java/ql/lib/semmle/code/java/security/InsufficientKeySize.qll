/** Provides classes and predicates related to insufficient key sizes in Java. */

private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.DataFlow

/** A source for an insufficient key size. */
abstract class InsufficientKeySizeSource extends DataFlow::Node {
  /** Holds if this source has the specified `state`. */
  predicate hasState(DataFlow::FlowState state) { state instanceof DataFlow::FlowStateEmpty }
}

/** A sink for an insufficient key size. */
abstract class InsufficientKeySizeSink extends DataFlow::Node {
  /** Holds if this sink has the specified `state`. */
  predicate hasState(DataFlow::FlowState state) { state instanceof DataFlow::FlowStateEmpty }
}

// *********************************** SOURCES ***********************************
/** A source for an insufficient key size used in RSA, DSA, and DH algorithms. */
private class AsymmetricNonEcSource extends InsufficientKeySizeSource {
  AsymmetricNonEcSource() { getNodeIntValue(this) < 2048 }

  override predicate hasState(DataFlow::FlowState state) { state = "2048" }
}

/** A source for an insufficient key size used in elliptic curve (EC) algorithms. */
private class AsymmetricEcSource extends InsufficientKeySizeSource {
  AsymmetricEcSource() {
    getNodeIntValue(this) < 256
    or
    // the below is needed for cases when the key size is embedded in the curve name
    getEcKeySize(this.asExpr().(StringLiteral).getValue()) < 256
  }

  override predicate hasState(DataFlow::FlowState state) { state = "256" }
}

/** A source for an insufficient key size used in AES algorithms. */
private class SymmetricSource extends InsufficientKeySizeSource {
  SymmetricSource() { getNodeIntValue(this) < 128 }

  override predicate hasState(DataFlow::FlowState state) { state = "128" }
}

// ************************** SOURCES HELPER PREDICATES **************************
/** Returns the integer value of a given Node. */
private int getNodeIntValue(DataFlow::Node node) {
  result = node.asExpr().(IntegerLiteral).getIntValue()
}

/** Returns the key size from an EC algorithm curve name string */
bindingset[algorithm]
private int getEcKeySize(string algorithm) {
  algorithm.matches("sec%") and // specification such as "secp256r1"
  result = algorithm.regexpCapture("sec[p|t](\\d+)[a-zA-Z].*", 1).toInt()
  or
  algorithm.matches("X9.62%") and //specification such as "X9.62 prime192v2"
  result = algorithm.regexpCapture("X9\\.62 .*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
  or
  (algorithm.matches("prime%") or algorithm.matches("c2tnb%")) and //specification such as "prime192v2"
  result = algorithm.regexpCapture(".*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
}

// ************************************ SINKS ************************************
/** A sink for an insufficient key size used in RSA, DSA, and DH algorithms. */
private class AsymmetricNonEcSink extends InsufficientKeySizeSink {
  AsymmetricNonEcSink() {
    exists(AsymmetricInitMethodAccess ma, AsymmetricKeyGenerator kg |
      kg.getAlgoName().matches(["RSA", "DSA", "DH"]) and
      DataFlow::localExprFlow(kg, ma.getQualifier()) and
      this.asExpr() = ma.getKeySizeArg()
    )
    or
    exists(AsymmetricNonEcSpec spec | this.asExpr() = spec.getKeySizeArg())
  }

  override predicate hasState(DataFlow::FlowState state) { state = "2048" }
}

/** A sink for an insufficient key size used in elliptic curve (EC) algorithms. */
private class AsymmetricEcSink extends InsufficientKeySizeSink {
  AsymmetricEcSink() {
    exists(AsymmetricInitMethodAccess ma, AsymmetricKeyGenerator kg |
      kg.getAlgoName().matches("EC%") and
      DataFlow::localExprFlow(kg, ma.getQualifier()) and
      this.asExpr() = ma.getKeySizeArg()
    )
    or
    exists(AsymmetricEcSpec s | this.asExpr() = s.getKeySizeArg())
  }

  override predicate hasState(DataFlow::FlowState state) { state = "256" }
}

/** A sink for an insufficient key size used in AES algorithms. */
private class SymmetricSink extends InsufficientKeySizeSink {
  SymmetricSink() {
    //hasKeySizeInInitMethod(this, "symmetric")
    exists(SymmetricInitMethodAccess ma, SymmetricKeyGenerator kg |
      kg.getAlgoName() = "AES" and
      DataFlow::localExprFlow(kg, ma.getQualifier()) and
      this.asExpr() = ma.getKeySizeArg()
    )
  }

  override predicate hasState(DataFlow::FlowState state) { state = "128" }
}

// ********************** SINKS HELPER CLASSES & PREDICATES **********************
/** A call to a method that initializes a key generator. */
abstract class KeyGenInitMethodAccess extends MethodAccess {
  /** Gets the `keysize` argument of this call. */
  Argument getKeySizeArg() { result = this.getArgument(0) }
}

/** A call to the `initialize` method declared in `java.security.KeyPairGenerator`. */
private class AsymmetricInitMethodAccess extends KeyGenInitMethodAccess {
  AsymmetricInitMethodAccess() { this.getMethod() instanceof KeyPairGeneratorInitMethod }
}

/** A call to the `init` method declared in `javax.crypto.KeyGenerator`. */
private class SymmetricInitMethodAccess extends KeyGenInitMethodAccess {
  SymmetricInitMethodAccess() { this.getMethod() instanceof KeyGeneratorInitMethod }
}

/** An instance of a key generator. */
abstract class KeyGeneratorObject extends JavaxCryptoAlgoSpec {
  string getAlgoName() { result = this.getAlgoSpec().(StringLiteral).getValue().toUpperCase() }
}

/** An instance of a `java.security.KeyPairGenerator`. */
private class AsymmetricKeyGenerator extends KeyGeneratorObject {
  AsymmetricKeyGenerator() { this instanceof JavaSecurityKeyPairGenerator }

  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}

/** An instance of a `javax.crypto.KeyGenerator`. */
private class SymmetricKeyGenerator extends KeyGeneratorObject {
  SymmetricKeyGenerator() { this instanceof JavaxCryptoKeyGenerator }

  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}

/** An instance of an algorithm specification. */
abstract class AlgoSpec extends ClassInstanceExpr {
  Argument getKeySizeArg() { result = this.getArgument(0) }
}

/** An instance of an RSA, DSA, or DH algorithm specification. */
private class AsymmetricNonEcSpec extends AlgoSpec {
  AsymmetricNonEcSpec() {
    this.getConstructedType() instanceof RsaKeyGenParameterSpec or
    this.getConstructedType() instanceof DsaGenParameterSpec or
    this.getConstructedType() instanceof DhGenParameterSpec
  }
}

/** An instance of an elliptic curve (EC) algorithm specification. */
private class AsymmetricEcSpec extends AlgoSpec {
  AsymmetricEcSpec() { this.getConstructedType() instanceof EcGenParameterSpec }
}
