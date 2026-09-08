/**
 * Provides classes and predicates for reasoning about weak key derivation
 * function (KDF) configurations using `Rfc2898DeriveBytes` (PBKDF2).
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow

/** Gets the minimum recommended PBKDF2 iteration count. */
int minIterationCount() { result = 100000 }

/** Gets the `System.Security.Cryptography` namespace. */
private API::Node cryptographyNamespace() {
  result =
    API::getTopLevelMember("system").getMember("security").getMember("cryptography")
}

/** Gets the `System.Security.Cryptography.Rfc2898DeriveBytes` type. */
private API::Node rfc2898DeriveBytesType() {
  result = cryptographyNamespace().getMember("rfc2898derivebytes")
}

/**
 * An instantiation of Rfc2898DeriveBytes via New-Object or [Type]::new().
 */
class Rfc2898DeriveBytesCreation extends DataFlow::CallNode {
  Rfc2898DeriveBytesCreation() { this = rfc2898DeriveBytesType().getInstance().asSource() }

  private DataFlow::Node getNewObjectArgumentList() {
    this.getExprNode().getExpr() instanceof DotNetObjectCreation and
    (
      result = this.getNamedArgument("argumentlist")
      or
      not this.hasNamedArgument("argumentlist") and result = this.getPositionalArgument(1)
    )
  }

  private DataFlow::Node getNewObjectArgument(int index) {
    exists(ArrayLiteral args |
      args = this.getNewObjectArgumentList().asExpr().getExpr() and
      result.asExpr().getExpr() = args.getExpr(index)
    )
    or
    exists(ParenExpr paren, ArrayLiteral args |
      paren = this.getNewObjectArgumentList().asExpr().getExpr() and
      args = paren.getExpr() and
      result.asExpr().getExpr() = args.getExpr(index)
    )
  }

  private predicate hasKnownNewObjectArgumentList() {
    this.getNewObjectArgumentList().asExpr().getExpr() instanceof ArrayLiteral
    or
    this.getNewObjectArgumentList().asExpr().getExpr().(ParenExpr).getExpr() instanceof ArrayLiteral
  }

  private DataFlow::Node getConstructorArgument(int index) {
    this.getExprNode().getExpr() instanceof NewObjectCreation and
    result = this.getPositionalArgument(index)
    or
    result = this.getNewObjectArgument(index)
  }

  /** Gets the iteration count argument (position 2, 0-indexed), if any. */
  DataFlow::Node getIterationCountArg() { result = this.getConstructorArgument(2) }

  /** Gets the hash algorithm argument (position 3, 0-indexed), if any. */
  DataFlow::Node getHashAlgorithmArg() { result = this.getConstructorArgument(3) }

  /** Holds if the constructor is known to omit the iteration count argument. */
  predicate hasDefaultIterationCount() {
    not this.getExprNode().getExpr() instanceof DotNetObjectCreation and
    not exists(this.getIterationCountArg())
    or
    this.hasKnownNewObjectArgumentList() and not exists(this.getNewObjectArgument(2))
  }

  /** Holds if the constructor is known to omit the hash algorithm argument. */
  predicate hasDefaultHashAlgorithm() {
    not this.getExprNode().getExpr() instanceof DotNetObjectCreation and
    not exists(this.getHashAlgorithmArg())
    or
    this.hasKnownNewObjectArgumentList() and not exists(this.getNewObjectArgument(3))
  }
}

/**
 * A call to the static Rfc2898DeriveBytes.Pbkdf2 method (.NET 6+).
 */
class Pbkdf2StaticCall extends DataFlow::CallNode {
  Pbkdf2StaticCall() { this = rfc2898DeriveBytesType().getMember("pbkdf2").asCall() }

  /** Gets the iteration count argument (position 2, 0-indexed). */
  DataFlow::Node getIterationCountArg() { result = this.getPositionalArgument(2) }

  /** Gets the hash algorithm argument (position 3, 0-indexed). */
  DataFlow::Node getHashAlgorithmArg() { result = this.getPositionalArgument(3) }
}

/**
 * Holds if `node` is an integer literal less than the minimum iteration count.
 */
predicate isLowIterationValue(DataFlow::Node node, int value) {
  value = node.asExpr().getExpr().getValue().asInt() and
  value < minIterationCount()
}

/**
 * Holds if `node` references a weak hash algorithm (MD5 or SHA1).
 */
predicate isWeakHashAlgorithm(DataFlow::Node node, string name) {
  // [HashAlgorithmName]::MD5 or [HashAlgorithmName]::SHA1
  node = cryptographyNamespace().getMember("hashalgorithmname").getMember(name).asSource() and
  name = ["md5", "sha1"]
  or
  // String literal "MD5" or "SHA1"
  exists(string s |
    s = node.asExpr().getExpr().getValue().asString().toLowerCase() and
    s = ["md5", "sha1"] and
    name = s
  )
}

/**
 * A weak key derivation function configuration that should be reported.
 */
abstract class WeakKdfConfig extends DataFlow::CallNode {
  abstract string getMessage();
}

/**
 * Rfc2898DeriveBytes created without specifying an iteration count.
 */
class DefaultIterationCountConfig extends WeakKdfConfig, Rfc2898DeriveBytesCreation {
  DefaultIterationCountConfig() { this.hasDefaultIterationCount() }

  override string getMessage() {
    result =
      "Rfc2898DeriveBytes uses default iteration count of 1000. Specify at least " +
        minIterationCount().toString() + " iterations."
  }
}

/**
 * Rfc2898DeriveBytes created with a low iteration count.
 */
class LowIterationCountConfig extends WeakKdfConfig, Rfc2898DeriveBytesCreation {
  LowIterationCountConfig() {
    isLowIterationValue(this.getIterationCountArg(), _)
  }

  override string getMessage() {
    exists(int value |
      isLowIterationValue(this.getIterationCountArg(), value) and
      result =
        "Rfc2898DeriveBytes uses iteration count of " + value.toString() +
          ", which is below the minimum of " + minIterationCount().toString() + "."
    )
  }
}

/**
 * Rfc2898DeriveBytes created without specifying a hash algorithm (defaults to SHA1).
 */
class DefaultHashAlgorithmConfig extends WeakKdfConfig, Rfc2898DeriveBytesCreation {
  DefaultHashAlgorithmConfig() { this.hasDefaultHashAlgorithm() }

  override string getMessage() {
    result = "Rfc2898DeriveBytes uses the default hash algorithm SHA1. Specify SHA-256 or stronger."
  }
}

/**
 * Rfc2898DeriveBytes created with a weak hash algorithm.
 */
class WeakHashAlgorithmConfig extends WeakKdfConfig, Rfc2898DeriveBytesCreation {
  WeakHashAlgorithmConfig() {
    isWeakHashAlgorithm(this.getHashAlgorithmArg(), _)
  }

  override string getMessage() {
    exists(string name |
      isWeakHashAlgorithm(this.getHashAlgorithmArg(), name) and
      result =
        "Rfc2898DeriveBytes uses weak hash algorithm " + name.toUpperCase() +
          ". Use SHA-256 or stronger."
    )
  }
}

/**
 * Rfc2898DeriveBytes.Pbkdf2 called with a low iteration count.
 */
class Pbkdf2LowIterationCountConfig extends WeakKdfConfig, Pbkdf2StaticCall {
  Pbkdf2LowIterationCountConfig() {
    isLowIterationValue(this.getIterationCountArg(), _)
  }

  override string getMessage() {
    exists(int value |
      isLowIterationValue(this.getIterationCountArg(), value) and
      result =
        "Rfc2898DeriveBytes.Pbkdf2 uses iteration count of " + value.toString() +
          ", which is below the minimum of " + minIterationCount().toString() + "."
    )
  }
}

/**
 * Rfc2898DeriveBytes.Pbkdf2 called with a weak hash algorithm.
 */
class Pbkdf2WeakHashAlgorithmConfig extends WeakKdfConfig, Pbkdf2StaticCall {
  Pbkdf2WeakHashAlgorithmConfig() {
    isWeakHashAlgorithm(this.getHashAlgorithmArg(), _)
  }

  override string getMessage() {
    exists(string name |
      isWeakHashAlgorithm(this.getHashAlgorithmArg(), name) and
      result =
        "Rfc2898DeriveBytes.Pbkdf2 uses weak hash algorithm " + name.toUpperCase() +
          ". Use SHA-256 or stronger."
    )
  }
}
