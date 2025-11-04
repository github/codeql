/**
 * Provides default sources, sinks and sanitizers for detecting "use of a
 * broken or weak cryptographic hashing algorithm on sensitive data"
 * vulnerabilities, as well as extension points for adding your own. This is
 * divided into two general cases:
 *  - hashing sensitive data
 *  - hashing passwords (which requires the hashing algorithm to be
 *    sufficiently computationally expensive in addition to other requirements)
 */

import go
private import semmle.go.security.SensitiveActions

/**
 * Provides default sources, sinks and sanitizers for detecting "use of a broken or weak
 * cryptographic hashing algorithm on sensitive data" vulnerabilities on sensitive data that does
 * NOT require computationally expensive hashing, as well as extension points for adding your own.
 *
 * Also see the `ComputationallyExpensiveHashFunction` module.
 */
module NormalHashFunction {
  /**
   * A data flow source for "use of a broken or weak cryptographic hashing algorithm on sensitive
   * data" vulnerabilities that does not require computationally expensive hashing. That is, a
   * piece of sensitive data that is not a password.
   */
  abstract class Source extends DataFlow::Node {
    Source() { not this instanceof ComputationallyExpensiveHashFunction::Source }

    /**
     * Gets the classification of the sensitive data.
     */
    abstract string getClassification();
  }

  /**
   * A data flow sink for "use of a broken or weak cryptographic hashing algorithm on sensitive
   * data" vulnerabilities that applies to data that does not require computationally expensive
   * hashing. That is, a broken or weak hashing algorithm.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the name of the weak hashing algorithm.
     */
    abstract string getAlgorithmName();
  }

  /**
   * A barrier for "use of a broken or weak cryptographic hashing algorithm on sensitive data"
   * vulnerabilities that applies to data that does not require computationally expensive hashing.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A flow source modeled by the `SensitiveData` library.
   */
  class SensitiveDataAsSource extends Source {
    SensitiveExpr::Classification classification;

    SensitiveDataAsSource() {
      classification = this.asExpr().(SensitiveExpr).getClassification() and
      not classification = SensitiveExpr::password() and // (covered in ComputationallyExpensiveHashFunction)
      not classification = SensitiveExpr::id() // (not accurate enough)
    }

    override SensitiveExpr::Classification getClassification() { result = classification }
  }

  /**
   * A flow sink modeled by the `Cryptography` module.
   */
  class WeakHashingOperationInputAsSink extends Sink {
    Cryptography::HashingAlgorithm algorithm;

    WeakHashingOperationInputAsSink() {
      exists(Cryptography::CryptographicOperation operation |
        algorithm.isWeak() and
        algorithm = operation.getAlgorithm() and
        this = operation.getAnInput()
      )
    }

    override string getAlgorithmName() { result = algorithm.getName() }
  }
}

/**
 * Provides default sources, sinks and sanitizers for detecting "use of a broken or weak
 * cryptographic hashing algorithm on sensitive data" vulnerabilities on sensitive data that DOES
 * require computationally expensive hashing, as well as extension points for adding your own.
 *
 * Also see the `NormalHashFunction` module.
 */
module ComputationallyExpensiveHashFunction {
  /**
   * A data flow source for "use of a broken or weak cryptographic hashing algorithm on sensitive
   * data" vulnerabilities that does require computationally expensive hashing. That is, a
   * password.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the classification of the sensitive data.
     */
    abstract string getClassification();
  }

  /**
   * A data flow sink for "use of a broken or weak cryptographic hashing algorithm on sensitive
   * data" vulnerabilities that applies to data that does require computationally expensive
   * hashing. That is, a broken or weak hashing algorithm or one that is not computationally
   * expensive enough for password hashing.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the name of the weak hashing algorithm.
     */
    abstract string getAlgorithmName();

    /**
     * Holds if this sink is for a computationally expensive hash function (meaning that hash
     * function is just weak in some other regard.
     */
    abstract predicate isComputationallyExpensive();
  }

  /**
   * A barrier for "use of a broken or weak cryptographic hashing algorithm on sensitive data"
   * vulnerabilities that applies to data that does require computationally expensive hashing.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A flow source modeled by the `SensitiveData` library.
   */
  class PasswordAsSource extends Source {
    SensitiveExpr::Classification classification;

    PasswordAsSource() {
      classification = this.asExpr().(SensitiveExpr).getClassification() and
      classification = SensitiveExpr::password()
    }

    override SensitiveExpr::Classification getClassification() { result = classification }
  }

  /**
   * A flow sink modeled by the `Cryptography` module.
   */
  class WeakPasswordHashingOperationInputSink extends Sink {
    Cryptography::CryptographicAlgorithm algorithm;

    WeakPasswordHashingOperationInputSink() {
      exists(Cryptography::CryptographicOperation operation |
        (
          algorithm instanceof Cryptography::PasswordHashingAlgorithm and
          algorithm.isWeak()
          or
          algorithm instanceof Cryptography::HashingAlgorithm // Note that HashingAlgorithm and PasswordHashingAlgorithm are disjoint
        ) and
        algorithm = operation.getAlgorithm() and
        this = operation.getAnInput()
      )
    }

    override string getAlgorithmName() { result = algorithm.getName() }

    override predicate isComputationallyExpensive() {
      algorithm instanceof Cryptography::PasswordHashingAlgorithm
    }
  }
}
