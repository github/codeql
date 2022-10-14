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

/** A source for an insufficient key size (asymmetric-non-ec: RSA, DSA, DH). */
private class AsymmetricNonEcSource extends InsufficientKeySizeSource {
  AsymmetricNonEcSource() { getNodeIntValue(this) < 2048 }

  override predicate hasState(DataFlow::FlowState state) { state = "2048" }
}

/** A source for an insufficient key size (asymmetric-ec: EC%). */
private class AsymmetricEcSource extends InsufficientKeySizeSource {
  AsymmetricEcSource() {
    getNodeIntValue(this) < 256 or
    getEcKeySize(this.asExpr().(StringLiteral).getValue()) < 256 // for cases when the key size is embedded in the curve name
  }

  override predicate hasState(DataFlow::FlowState state) { state = "256" }
}

/** A source for an insufficient key size (symmetric: AES). */
private class SymmetricSource extends InsufficientKeySizeSource {
  SymmetricSource() { getNodeIntValue(this) < 128 }

  override predicate hasState(DataFlow::FlowState state) { state = "128" }
}

private int getNodeIntValue(DataFlow::Node node) {
  result = node.asExpr().(IntegerLiteral).getIntValue()
}

// TODO: check if any other regex should be added based on some MRVA results.
/** Returns the key size in the EC algorithm string */
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

/** A sink for an insufficient key size (asymmetric-non-ec). */
private class AsymmetricNonEcSink extends InsufficientKeySizeSink {
  AsymmetricNonEcSink() {
    // hasKeySizeInInitMethod(this, "asymmetric-non-ec")
    // or
    //hasKeySizeInSpec(this, "asymmetric-non-ec")
    exists(AsymmInitMethodAccess ma, AsymmKeyGen kg |
      kg.getAlgoName().matches(["RSA", "DSA", "DH"]) and
      DataFlow::localExprFlow(kg, ma.getQualifier()) and
      this.asExpr() = ma.getKeySizeArg()
    )
    or
    exists(AsymmetricNonEcSpec s | this.asExpr() = s.getKeySizeArg())
  }

  override predicate hasState(DataFlow::FlowState state) { state = "2048" }
}

/** A sink for an insufficient key size (asymmetric-ec). */
private class AsymmetricEcSink extends InsufficientKeySizeSink {
  AsymmetricEcSink() {
    // hasKeySizeInInitMethod(this, "asymmetric-ec")
    // or
    //hasKeySizeInSpec(this, "asymmetric-ec")
    exists(AsymmInitMethodAccess ma, AsymmKeyGen kg |
      kg.getAlgoName().matches("EC%") and
      DataFlow::localExprFlow(kg, ma.getQualifier()) and
      this.asExpr() = ma.getKeySizeArg()
    )
    or
    exists(AsymmetricEcSpec s | this.asExpr() = s.getKeySizeArg())
  }

  override predicate hasState(DataFlow::FlowState state) { state = "256" }
}

/** A sink for an insufficient key size (symmetric). */
private class SymmetricSink extends InsufficientKeySizeSink {
  SymmetricSink() {
    //hasKeySizeInInitMethod(this, "symmetric")
    exists(SymmInitMethodAccess ma, SymmKeyGen kg |
      kg.getAlgoName() = "AES" and
      DataFlow::localExprFlow(kg, ma.getQualifier()) and
      this.asExpr() = ma.getKeySizeArg()
    )
  }

  override predicate hasState(DataFlow::FlowState state) { state = "128" }
}

abstract class InitMethodAccess extends MethodAccess {
  Argument getKeySizeArg() { result = this.getArgument(0) }
}

class AsymmInitMethodAccess extends InitMethodAccess {
  AsymmInitMethodAccess() { this.getMethod() instanceof KeyPairGeneratorInitMethod }
}

class SymmInitMethodAccess extends InitMethodAccess {
  SymmInitMethodAccess() { this.getMethod() instanceof KeyGeneratorInitMethod }
}

abstract class KeyGen extends JavaxCryptoAlgoSpec {
  string getAlgoName() { result = this.getAlgoSpec().(StringLiteral).getValue().toUpperCase() }
}

class AsymmKeyGen extends KeyGen {
  AsymmKeyGen() { this instanceof JavaSecurityKeyPairGenerator }

  // ! this override is repetitive...
  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}

class SymmKeyGen extends KeyGen {
  SymmKeyGen() { this instanceof JavaxCryptoKeyGenerator }

  // ! this override is repetitive...
  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}

// ! use below instead of/in above?? (actually I don't think I need any of this, can just use AsymmetricNonEcSpec and EcGenParameterSpec directly???)
// Algo spec
abstract class AsymmetricAlgoSpec extends ClassInstanceExpr {
  Argument getKeySizeArg() { result = this.getArgument(0) }
}

class AsymmetricNonEcSpec extends AsymmetricAlgoSpec {
  AsymmetricNonEcSpec() {
    this.getConstructedType() instanceof RsaKeyGenParameterSpec or
    this.getConstructedType() instanceof DsaGenParameterSpec or
    this.getConstructedType() instanceof DhGenParameterSpec
  }
}

class AsymmetricEcSpec extends AsymmetricAlgoSpec {
  AsymmetricEcSpec() { this.getConstructedType() instanceof EcGenParameterSpec }
}
// TODO:
// todo #0: look into use of specs without keygen objects; should spec not be a sink in these cases?
// todo #3: make list of algo names more easily reusable (either as constant-type variable at top of file, or model as own class to share, etc.)
// todo: add barrier guard for !=0 conditional case
// todo: only update key sizes (and key size strings) in one place in the code
