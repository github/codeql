/** Provides classes and predicates related to insufficient key sizes in Java. */

private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.DataFlow

/** A source for an insufficient key size. */
abstract class InsufficientKeySizeSource extends DataFlow::Node { }

/** A sink for an insufficient key size. */
abstract class InsufficientKeySizeSink extends DataFlow::Node { }

// TODO: Consider if below 3 sources should be private and if it's possible to only use InsufficientKeySizeSource in the configs
// TODO: add QLDocs if keeping non-private
class AsymmetricNonECSource extends InsufficientKeySizeSource {
  AsymmetricNonECSource() { getNodeIntValue(this) < 2048 }
}

class AsymmetricECSource extends InsufficientKeySizeSource {
  AsymmetricECSource() {
    getNodeIntValue(this) < 256 or
    getECKeySize(this.asExpr().(StringLiteral).getValue()) < 256 // need this for the cases when the key size is embedded in the curve name.
  }
}

class SymmetricSource extends InsufficientKeySizeSource {
  SymmetricSource() { getNodeIntValue(this) < 128 }
}

private int getNodeIntValue(DataFlow::Node node) {
  result = node.asExpr().(IntegerLiteral).getIntValue()
}

/** Returns the key size in the EC algorithm string */
bindingset[algorithm]
private int getECKeySize(string algorithm) {
  algorithm.matches("sec%") and // specification such as "secp256r1"
  result = algorithm.regexpCapture("sec[p|t](\\d+)[a-zA-Z].*", 1).toInt()
  or
  algorithm.matches("X9.62%") and //specification such as "X9.62 prime192v2"
  result = algorithm.regexpCapture("X9\\.62 .*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
  or
  (algorithm.matches("prime%") or algorithm.matches("c2tnb%")) and //specification such as "prime192v2"
  result = algorithm.regexpCapture(".*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
}

class AsymmetricNonECSink extends InsufficientKeySizeSink {
  AsymmetricNonECSink() {
    exists(MethodAccess ma, JavaSecurityKeyPairGenerator jpg |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches(["RSA", "DSA", "DH"]) and
      DataFlow::localExprFlow(jpg, ma.getQualifier()) and
      this.asExpr() = ma.getArgument(0)
    )
    or
    exists(ClassInstanceExpr genParamSpec |
      genParamSpec.getConstructedType() instanceof AsymmetricNonECSpec and
      this.asExpr() = genParamSpec.getArgument(0)
    )
  }
}

// TODO: move to Encryption.qll? or keep here since specific to this query?
private class AsymmetricNonECSpec extends RefType {
  AsymmetricNonECSpec() {
    this instanceof RsaKeyGenParameterSpec or
    this instanceof DsaGenParameterSpec or
    this instanceof DhGenParameterSpec
  }
}

class AsymmetricECSink extends InsufficientKeySizeSink {
  AsymmetricECSink() {
    exists(MethodAccess ma, JavaSecurityKeyPairGenerator jpg |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches("EC%") and
      DataFlow::localExprFlow(jpg, ma.getQualifier()) and
      this.asExpr() = ma.getArgument(0)
    )
    or
    exists(ClassInstanceExpr ecGenParamSpec |
      ecGenParamSpec.getConstructedType() instanceof EcGenParameterSpec and
      this.asExpr() = ecGenParamSpec.getArgument(0)
    )
  }
}

class SymmetricSink extends InsufficientKeySizeSink {
  SymmetricSink() {
    exists(MethodAccess ma, JavaxCryptoKeyGenerator jcg |
      ma.getMethod() instanceof KeyGeneratorInitMethod and
      jcg.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = "AES" and
      DataFlow::localExprFlow(jcg, ma.getQualifier()) and
      this.asExpr() = ma.getArgument(0)
    )
  }
}
// TODO:
// todo #0: look into use of specs without keygen objects; should spec not be a sink in these cases?
// todo #3: make list of algo names more easily reusable (either as constant-type variable at top of file, or model as own class to share, etc.)
// todo #5:
