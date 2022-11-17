/** Provides classes and predicates related to insufficient key sizes in Java. */

private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.security.internal.EncryptionKeySizes

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

/** Provides models for asymmetric cryptography. */
private module Asymmetric {
  /** Provides models for non-elliptic-curve asymmetric cryptography. */
  private module NonEllipticCurve {
    private module Rsa {
      /** A source for an insufficient key size used in an RSA algorithm. */
      private class Source extends InsufficientKeySizeSource {
        Source() { this.asExpr().(IntegerLiteral).getIntValue() < getMinKeySize() }

        override predicate hasState(DataFlow::FlowState state) {
          state = getMinKeySize().toString()
        }
      }

      /** A sink for an insufficient key size used in an RSA algorithm. */
      private class Sink extends InsufficientKeySizeSink {
        Sink() {
          exists(KeyPairGenInit kpgInit, KeyPairGen kpg |
            kpg.getAlgoName() = "RSA" and
            DataFlow::localExprFlow(kpg, kpgInit.getQualifier()) and
            this.asExpr() = kpgInit.getKeySizeArg()
          )
          or
          exists(Spec spec | this.asExpr() = spec.getKeySizeArg())
        }

        override predicate hasState(DataFlow::FlowState state) {
          state = getMinKeySize().toString()
        }
      }

      /** Returns the minimum recommended key size for an RSA algorithm. */
      private int getMinKeySize() { result = minSecureKeySizeRsa() }

      /** An instance of an RSA algorithm specification. */
      private class Spec extends ClassInstanceExpr {
        Spec() { this.getConstructedType() instanceof RsaKeyGenParameterSpec }

        /** Gets the `keysize` argument of this instance. */
        Argument getKeySizeArg() { result = this.getArgument(0) }
      }
    }

    private module Dsa {
      /** A source for an insufficient key size used a DSA algorithm. */
      private class Source extends InsufficientKeySizeSource {
        Source() { this.asExpr().(IntegerLiteral).getIntValue() < getMinKeySize() }

        override predicate hasState(DataFlow::FlowState state) {
          state = getMinKeySize().toString()
        }
      }

      /** A sink for an insufficient key size used in a DSA algorithm. */
      private class Sink extends InsufficientKeySizeSink {
        Sink() {
          exists(KeyPairGenInit kpgInit, KeyPairGen kpg |
            kpg.getAlgoName() = "DSA" and
            DataFlow::localExprFlow(kpg, kpgInit.getQualifier()) and
            this.asExpr() = kpgInit.getKeySizeArg()
          )
          or
          exists(Spec spec | this.asExpr() = spec.getKeySizeArg())
        }

        override predicate hasState(DataFlow::FlowState state) {
          state = getMinKeySize().toString()
        }
      }

      /** Returns the minimum recommended key size for a DSA algorithm. */
      private int getMinKeySize() { result = minSecureKeySizeDsa() }

      /** An instance of a DSA algorithm specification. */
      private class Spec extends ClassInstanceExpr {
        Spec() { this.getConstructedType() instanceof DsaGenParameterSpec }

        /** Gets the `keysize` argument of this instance. */
        Argument getKeySizeArg() { result = this.getArgument(0) }
      }
    }

    private module Dh {
      /** A source for an insufficient key size used in a DH algorithm. */
      private class Source extends InsufficientKeySizeSource {
        Source() { this.asExpr().(IntegerLiteral).getIntValue() < getMinKeySize() }

        override predicate hasState(DataFlow::FlowState state) {
          state = getMinKeySize().toString()
        }
      }

      /** A sink for an insufficient key size used in a DH algorithm. */
      private class Sink extends InsufficientKeySizeSink {
        Sink() {
          exists(KeyPairGenInit kpgInit, KeyPairGen kpg |
            kpg.getAlgoName() = "DH" and
            DataFlow::localExprFlow(kpg, kpgInit.getQualifier()) and
            this.asExpr() = kpgInit.getKeySizeArg()
          )
          or
          exists(Spec spec | this.asExpr() = spec.getKeySizeArg())
        }

        override predicate hasState(DataFlow::FlowState state) {
          state = getMinKeySize().toString()
        }
      }

      /** Returns the minimum recommended key size for a DH algorithm. */
      private int getMinKeySize() { result = minSecureKeySizeDh() }

      /** An instance of an RSA, DSA, or DH algorithm specification. */
      private class Spec extends ClassInstanceExpr {
        Spec() { this.getConstructedType() instanceof DhGenParameterSpec }

        /** Gets the `keysize` argument of this instance. */
        Argument getKeySizeArg() { result = this.getArgument(0) }
      }
    }
  }

  /** Provides models for elliptic-curve asymmetric cryptography. */
  private module EllipticCurve {
    /** A source for an insufficient key size used in elliptic curve (EC) algorithms. */
    private class Source extends InsufficientKeySizeSource {
      Source() {
        this.asExpr().(IntegerLiteral).getIntValue() < getMinKeySize()
        or
        // the below is needed for cases when the key size is embedded in the curve name
        getKeySize(this.asExpr().(StringLiteral).getValue()) < getMinKeySize()
      }

      override predicate hasState(DataFlow::FlowState state) { state = getMinKeySize().toString() }
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

      override predicate hasState(DataFlow::FlowState state) { state = getMinKeySize().toString() }
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
  private class KeyPairGenInit extends MethodAccess {
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
  /** A source for an insufficient key size used in AES algorithms. */
  private class Source extends InsufficientKeySizeSource {
    Source() { this.asExpr().(IntegerLiteral).getIntValue() < getMinKeySize() }

    override predicate hasState(DataFlow::FlowState state) { state = getMinKeySize().toString() }
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

    override predicate hasState(DataFlow::FlowState state) { state = getMinKeySize().toString() }
  }

  /** Returns the minimum recommended key size for AES algorithms. */
  private int getMinKeySize() { result = minSecureKeySizeAes() }

  /** A call to the `init` method declared in `javax.crypto.KeyGenerator`. */
  private class KeyGenInit extends MethodAccess {
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
