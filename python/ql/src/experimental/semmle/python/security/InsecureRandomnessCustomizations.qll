/**
 * Provides default sources, sinks and sanitizers for reasoning about random values that are
 * not cryptographically secure, as well as extension points for adding your own.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.Concepts
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.dataflow.new.internal.DataFlowPrivate

/**
 * Provides default sources, sinks and sanitizers for reasoning about random values that are
 * not cryptographically secure, as well as extension points for adding your own.
 */
module InsecureRandomness {
  /**
   * A data flow source for random values that are not cryptographically secure.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for random values that are not cryptographically secure.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for random values that are not cryptographically secure.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A random source that is not sufficient for security use. So far this is only made up
   * of the math package's rand function, more insufficient random sources can be added here.
   */
  class InsecureRandomSource extends Source {
    InsecureRandomSource() {
      this =
        API::moduleImport("random")
            .getMember([
                "betavariate", "choice", "choices", "expovariate", "gammavariate", "gauss",
                "getrandbits", "getstate", "lognormvariate", "normalvariate", "paretovariate",
                "randbytes", "randint", "random", "randrange", "sample", "seed", "setstate",
                "shuffle", "triangular", "uniform", "vonmisesvariate", "weibullvariate"
              ])
            .getACall()
    }
  }

  /**
   * A use in a function that heuristically deals with unsafe random numbers or random strings.
   */
  class RandomFnSink extends Sink {
    RandomFnSink() {
      exists(Function func |
        func.getName()
            .regexpMatch("(?i).*(gen(erate)?|make|mk|create).*(nonce|salt|pepper|Password).*")
      |
        this.asExpr().getScope() = func
      )
    }
  }

  /**
   * A cryptographic key, considered as a sink for random values that are not cryptographically
   * secure.
   */
  class CryptoKeySink extends Sink {
    CryptoKeySink() {
      exists(Cryptography::CryptographicOperation operation | this = operation.getAnInput())
    }
  }
}
