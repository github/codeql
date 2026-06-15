/**
 * Provides default sources, sinks and sanitizers for reasoning about random values that are
 * not cryptographically secure, as well as extension points for adding your own.
 */

import go

/**
 * Provides default sources, sinks and sanitizers for reasoning about random values that are
 * not cryptographically secure, as well as extension points for adding your own.
 */
module InsecureRandomness {
  /**
   * A data flow source for insufficient random sources
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for cryptographic algorithms that take a key as input
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a string describing the kind of sink this is. */
    abstract string getKind();
  }

  /**
   * A sanitizer for insufficient random sources used as cryptographic keys
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A random source that is not sufficient for security use. So far this is only made up
   * of the math package's rand function, more insufficient random sources can be added here.
   */
  class InsecureRandomSource extends Source, DataFlow::CallNode {
    InsecureRandomSource() { this.getTarget().getPackage().getPath() = "math/rand" }
  }

  /**
   * Gets an interface outside of the `crypto` package which is the same as an
   * interface in the `crypto` package.
   */
  string nonCryptoInterface() {
    result = ["io.Writer", "io.Reader", "sync.Map", "sync.Mutex", "net.Listener"]
  }

  /**
   * A cryptographic algorithm.
   */
  class CryptographicSink extends Sink {
    CryptographicSink() {
      exists(Function fn, string pkg, string name |
        not fn instanceof Method and fn.hasQualifiedName(pkg, name)
        or
        fn.(Method).hasQualifiedName(pkg, _, name)
      |
        pkg.regexpMatch("crypto/.*") and
        not pkg = getAHashPkg() and
        not (pkg = "crypto/rand" and name = "Read") and
        // `crypto/cipher` APIs for reading/writing encrypted streams
        not (pkg = "crypto/cipher" and name = ["Read", "Write"]) and
        not (pkg = "crypto/tls" and name = ["Client", "Dial", "DialWithDialer"]) and
        // Some interfaces in the `crypto` package are the same as interfaces
        // elsewhere, e.g. tls.listener is the same as net.Listener
        not fn.hasQualifiedName(nonCryptoInterface(), _) and
        exists(DataFlow::CallNode call | call.getTarget() = fn and this = call.getAnArgument())
      )
    }

    override string getKind() { result = "This cryptographic algorithm" }
  }

  /**
   * A use in a function that heuristically deals with passwords.
   */
  class PasswordFnSink extends Sink {
    PasswordFnSink() {
      this.getRoot().(FuncDef).getName().regexpMatch("(?i).*(gen(erate)?|salt|make|mk)Password.*")
    }

    override string getKind() { result = "A password-related function" }
  }

  /** Gets a package that implements hash algorithms. */
  bindingset[result]
  private string getAHashPkg() { result.regexpMatch("crypto/(md5|sha(1|256|512)|rand)") }

  /**
   * A function that hashes input, which is considered as a taint propagator for use of
   * cryptographically insecure random values.
   */
  class HashAlgorithm extends TaintTracking::FunctionModel {
    HashAlgorithm() {
      exists(Method m | this = m |
        m.implements("hash", "Hash", "Sum")
        or
        m.implements("hash", "Hash32", "Sum32")
        or
        m.implements("hash", "Hash64", "Sum64")
      )
      or
      exists(string pkg, string name | this.hasQualifiedName(pkg, name) |
        pkg = getAHashPkg() and name.matches("Sum%")
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      if this instanceof Method
      then (
        inp.isReceiver() and outp.isResult()
      ) else (
        inp.isParameter(0) and outp.isResult()
      )
    }
  }
}
