/**
 * Provides classes for modeling cryptographic libraries.
 */

import go
import semmle.go.Concepts::Cryptography
private import codeql.concepts.internal.CryptoAlgorithmNames

/**
 * A cryptographic operation from the `crypto/md5` package.
 */
private module CryptoMd5 {
  private class Md5 extends CryptographicOperation::Range instanceof DataFlow::CallNode {
    Md5() { this.getTarget().hasQualifiedName("crypto/md5", ["New", "Sum"]) }

    override DataFlow::Node getInitialization() { result = this }

    override CryptographicAlgorithm getAlgorithm() { result.matchesName("MD5") }

    override DataFlow::Node getAnInput() { result = super.getArgument(0) }

    // not relevant for md5
    override BlockMode getBlockMode() { none() }
  }
}

/**
 * A cryptographic operation from the `crypto/sha1` package.
 */
class Sha1 extends CryptographicOperation::Range instanceof DataFlow::CallNode {
  Sha1() { this.getTarget().hasQualifiedName("crypto/sha1", ["New", "Sum"]) }

  override Expr getInput() { result = this.getArgument(0).asExpr() }

  override CryptographicAlgorithm getAlgorithm() {
    result.matchesName(this.getTarget().getPackage().getName())
  }
}

/**
 * A cryptographic operation from the `crypto/des` package.
 */
class Des extends CryptographicOperation::Range instanceof DataFlow::CallNode {
  Des() { this.getTarget().hasQualifiedName("crypto/des", ["NewCipher", "NewTripleDESCipher"]) }

  override Expr getInput() { result = this.getArgument(0).asExpr() }

  override CryptographicAlgorithm getAlgorithm() {
    result.matchesName(this.getTarget().getPackage().getName())
  }
}

/**
 * A cryptographic operation from the `crypto/rc4` package.
 */
class Rc4 extends CryptographicOperation::Range instanceof DataFlow::CallNode {
  Rc4() { this.getTarget().hasQualifiedName("crypto/rc4", "NewCipher") }

  override Expr getInput() { result = this.getArgument(0).asExpr() }

  override CryptographicAlgorithm getAlgorithm() {
    result.matchesName(this.getTarget().getPackage().getName())
  }
}
