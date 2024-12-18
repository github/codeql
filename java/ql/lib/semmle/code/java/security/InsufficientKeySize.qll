/** Provides classes and predicates related to insufficient key sizes in Java. */

private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.security.internal.EncryptionKeySizes
private import codeql.util.Either

/** A minimum recommended key size for some algorithm. */
abstract class MinimumKeySize extends int {
  bindingset[this]
  MinimumKeySize() { any() }

  /** Gets a textual representation of this element. */
  string toString() { result = super.toString() }
}

/**
 * A class of algorithms for which a key size smaller than the recommended key
 * size might be embedded in the algorithm name.
 */
abstract class AlgorithmKind extends string {
  bindingset[this]
  AlgorithmKind() { any() }

  /** Gets a textual representation of this element. */
  string toString() { result = super.toString() }
}

/**
 * A key size that is greater than the tracked value and equal to the minimum
 * recommended key size for some algorithm, or a kind of algorithm for which the
 * tracked string indicates a too small key size.
 */
final class KeySizeState = Either<MinimumKeySize, AlgorithmKind>::Either;

/** A source for an insufficient key size. */
abstract class InsufficientKeySizeSource extends DataFlow::Node {
  /** Holds if this source has the specified `state`. */
  abstract predicate hasState(KeySizeState state);
}

/** A sink for an insufficient key size. */
abstract class InsufficientKeySizeSink extends DataFlow::Node {
  /** Holds if this sink accepts the specified `state`. */
  final predicate hasState(KeySizeState state) {
    state.asLeft() <= this.minimumKeySize() or this.algorithmKind(state.asRight())
  }

  /** Gets the minimum recommended key size. */
  abstract int minimumKeySize();

  /**
   * Holds if this sink recommends a keysize that is greater than the value in a
   * source with the given algorithm kind.
   */
  predicate algorithmKind(AlgorithmKind kind) { none() }
}

/** A source for an insufficient key size used in some algorithm. */
private class IntegerLiteralSource extends InsufficientKeySizeSource {
  private int value;

  IntegerLiteralSource() { this.asExpr().(IntegerLiteral).getIntValue() = value }

  override predicate hasState(KeySizeState state) {
    state.asLeft() = min(MinimumKeySize m | value < m)
  }
}

/** Provides models for asymmetric cryptography. */
private module Asymmetric {
  /** Provides models for non-elliptic-curve asymmetric cryptography. */
  private module NonEllipticCurve {
    private class NonEllipticCurveKeySize extends MinimumKeySize {
      NonEllipticCurveKeySize() { this = getMinKeySize(_) }
    }

    /** A sink for an insufficient key size used in RSA, DSA, and DH algorithms. */
    private class Sink extends InsufficientKeySizeSink {
      string algoName;

      Sink() {
        exists(KeyPairGenInit kpgInit, KeyPairGen kpg |
          algoName in ["RSA", "DSA", "DH"] and
          kpg.getAlgoName() = algoName and
          DataFlow::localExprFlow(kpg, kpgInit.getQualifier()) and
          this.asExpr() = kpgInit.getKeySizeArg()
        )
        or
        exists(Spec spec | this.asExpr() = spec.getKeySizeArg() and algoName = spec.getAlgoName())
      }

      override int minimumKeySize() { result = getMinKeySize(algoName) }
    }

    /** Returns the minimum recommended key size for RSA, DSA, and DH algorithms. */
    private int getMinKeySize(string algoName) {
      algoName = "RSA" and
      result = minSecureKeySizeRsa()
      or
      algoName = "DSA" and
      result = minSecureKeySizeDsa()
      or
      algoName = "DH" and
      result = minSecureKeySizeDh()
    }

    /** An instance of an RSA, DSA, or DH algorithm specification. */
    private class Spec extends ClassInstanceExpr {
      string algoName;

      Spec() {
        this.getConstructedType() instanceof RsaKeyGenParameterSpec and
        algoName = "RSA"
        or
        this.getConstructedType() instanceof DsaGenParameterSpec and
        algoName = "DSA"
        or
        this.getConstructedType() instanceof DhGenParameterSpec and
        algoName = "DH"
      }

      /** Gets the `keysize` argument of this instance. */
      Argument getKeySizeArg() { result = this.getArgument(0) }

      /** Gets the algorithm name of this spec. */
      string getAlgoName() { result = algoName }
    }
  }

  /** Provides models for elliptic-curve asymmetric cryptography. */
  private module EllipticCurve {
    private class EllipticCurveKeySize extends MinimumKeySize {
      EllipticCurveKeySize() { this = getMinKeySize() }
    }

    private class EllipticCurveKind extends AlgorithmKind {
      EllipticCurveKind() { this = "EC" }
    }

    /** A source for an insufficient key size used in elliptic curve (EC) algorithms. */
    private class Source extends InsufficientKeySizeSource {
      Source() {
        // the below is needed for cases when the key size is embedded in the curve name
        getKeySize(this.asExpr().(StringLiteral).getValue()) < getMinKeySize()
      }

      override predicate hasState(KeySizeState state) {
        state.asRight() instanceof EllipticCurveKind
      }
    }

    /** A sink for an insufficient key size used in elliptic curve (EC) algorithms. */
    private class Sink extends InsufficientKeySizeSink {
      Sink() {
        exists(KeyPairGenInit kpgInit, KeyPairGen kpg |
          kpg.getAlgoName().matches("EC%") and
          DataFlow::localExprFlow(kpg, kpgInit.getQualifier()) and
          this.asExpr() = kpgInit.getKeySizeArg()
        )
        or
        exists(Spec s | this.asExpr() = s.getKeySizeArg())
      }

      override int minimumKeySize() { result = getMinKeySize() }

      override predicate algorithmKind(AlgorithmKind kind) { kind instanceof EllipticCurveKind }
    }

    /** Returns the minimum recommended key size for elliptic curve (EC) algorithms. */
    private int getMinKeySize() { result = minSecureKeySizeEcc() }

    /** Returns the key size from an EC algorithm's curve name string */
    bindingset[algorithm]
    private int getKeySize(string algorithm) {
      algorithm.matches("sec%") and // specification such as "secp256r1"
      result = algorithm.regexpCapture("sec[p|t](\\d+)[a-zA-Z].*", 1).toInt()
      or
      algorithm.matches("X9.62%") and // specification such as "X9.62 prime192v2"
      result = algorithm.regexpCapture("X9\\.62 .*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
      or
      algorithm.matches(["prime%", "c2tnb%"]) and // specification such as "prime192v2"
      result = algorithm.regexpCapture(".*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
    }

    /** An instance of an elliptic curve (EC) algorithm specification. */
    private class Spec extends ClassInstanceExpr {
      Spec() { this.getConstructedType() instanceof EcGenParameterSpec }

      /** Gets the `keysize` argument of this instance. */
      Argument getKeySizeArg() { result = this.getArgument(0) }
    }
  }

  /**
   * A call to the `initialize` method declared in `java.security.KeyPairGenerator`
   * or to the `init` method declared in `java.security.AlgorithmParameterGenerator`.
   */
  private class KeyPairGenInit extends MethodCall {
    KeyPairGenInit() {
      this.getMethod() instanceof KeyPairGeneratorInitMethod or
      this.getMethod() instanceof AlgoParamGeneratorInitMethod
    }

    /** Gets the `keysize` argument of this call. */
    Argument getKeySizeArg() { result = this.getArgument(0) }
  }

  /**
   * An instance of a `java.security.KeyPairGenerator`
   * or of a `java.security.AlgorithmParameterGenerator`.
   */
  private class KeyPairGen extends GeneratorAlgoSpec {
    KeyPairGen() {
      this instanceof JavaSecurityKeyPairGenerator or
      this instanceof JavaSecurityAlgoParamGenerator
    }

    override Expr getAlgoSpec() {
      result =
        [
          this.(JavaSecurityKeyPairGenerator).getAlgoSpec(),
          this.(JavaSecurityAlgoParamGenerator).getAlgoSpec()
        ]
    }
  }
}

/** Provides models for symmetric cryptography. */
private module Symmetric {
  private class SymmetricKeySize extends MinimumKeySize {
    SymmetricKeySize() { this = getMinKeySize() }
  }

  /** A sink for an insufficient key size used in AES algorithms. */
  private class Sink extends InsufficientKeySizeSink {
    Sink() {
      exists(KeyGenInit kgInit, KeyGen kg |
        kg.getAlgoName() = "AES" and
        DataFlow::localExprFlow(kg, kgInit.getQualifier()) and
        this.asExpr() = kgInit.getKeySizeArg()
      )
    }

    override int minimumKeySize() { result = getMinKeySize() }
  }

  /** Returns the minimum recommended key size for AES algorithms. */
  private int getMinKeySize() { result = minSecureKeySizeAes() }

  /** A call to the `init` method declared in `javax.crypto.KeyGenerator`. */
  private class KeyGenInit extends MethodCall {
    KeyGenInit() { this.getMethod() instanceof KeyGeneratorInitMethod }

    /** Gets the `keysize` argument of this call. */
    Argument getKeySizeArg() { result = this.getArgument(0) }
  }

  /** An instance of a `javax.crypto.KeyGenerator`. */
  private class KeyGen extends GeneratorAlgoSpec instanceof JavaxCryptoKeyGenerator {
    override Expr getAlgoSpec() { result = JavaxCryptoKeyGenerator.super.getAlgoSpec() }
  }
}

/** An instance of a generator that specifies an encryption algorithm. */
abstract private class GeneratorAlgoSpec extends CryptoAlgoSpec {
  /** Returns an uppercase string representing the algorithm name specified by this generator object. */
  string getAlgoName() {
    result = this.getAlgoSpec().(CompileTimeConstantExpr).getStringValue().toUpperCase()
  }
}
