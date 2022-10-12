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

// TODO: use `typeFlag` like with sinks below to include the size numbers in this predicate?
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

// TODO: Consider if below 3 sinks should be private and if it's possible to only use InsufficientKeySizeSink in the configs
// TODO: add QLDocs if keeping non-private
class AsymmetricNonECSink extends InsufficientKeySizeSink {
  AsymmetricNonECSink() {
    hasKeySizeInInitMethod(this, "asymmetric-non-ec")
    or
    hasKeySizeInSpec(this, "asymmetric-non-ec")
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
    hasKeySizeInInitMethod(this, "asymmetric-ec")
    or
    hasKeySizeInSpec(this, "asymmetric-ec")
  }
}

class SymmetricSink extends InsufficientKeySizeSink {
  SymmetricSink() { hasKeySizeInInitMethod(this, "symmetric") }
}

// TODO: rethink the predicate name; also think about whether this could/should be a class instead; or a predicate within the sink class so can do sink.predicate()...
// TODO: can prbly re-work way using the typeFlag to be better and less repetitive
private predicate hasKeySizeInInitMethod(DataFlow::Node node, string typeFlag) {
  exists(MethodAccess ma, JavaxCryptoAlgoSpec jcaSpec |
    (
      ma.getMethod() instanceof KeyGeneratorInitMethod and typeFlag = "symmetric"
      or
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and typeFlag.matches("asymmetric%")
    ) and
    (
      jcaSpec instanceof JavaxCryptoKeyGenerator and typeFlag = "symmetric"
      or
      jcaSpec instanceof JavaSecurityKeyPairGenerator and typeFlag.matches("asymmetric%")
    ) and
    (
      jcaSpec.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = "AES" and
      typeFlag = "symmetric"
      or
      jcaSpec.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches(["RSA", "DSA", "DH"]) and
      typeFlag = "asymmetric-non-ec"
      or
      jcaSpec.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches("EC%") and
      typeFlag = "asymmetric-ec"
    ) and
    DataFlow::localExprFlow(jcaSpec, ma.getQualifier()) and
    node.asExpr() = ma.getArgument(0)
  )
}

// TODO: rethink the predicate name; also think about whether this could/should be a class instead; or a predicate within the sink class so can do sink.predicate()...
// TODO: can prbly re-work way using the typeFlag to be better and less repetitive
private predicate hasKeySizeInSpec(DataFlow::Node node, string typeFlag) {
  exists(ClassInstanceExpr paramSpec |
    (
      paramSpec.getConstructedType() instanceof AsymmetricNonECSpec and
      typeFlag = "asymmetric-non-ec"
      or
      paramSpec.getConstructedType() instanceof EcGenParameterSpec and
      typeFlag = "asymmetric-ec"
    ) and
    node.asExpr() = paramSpec.getArgument(0)
  )
}
// TODO:
// todo #0: look into use of specs without keygen objects; should spec not be a sink in these cases?
// todo #3: make list of algo names more easily reusable (either as constant-type variable at top of file, or model as own class to share, etc.)
// todo #4: use flowstate (or even just result predicate) to pass source int size to sink?
