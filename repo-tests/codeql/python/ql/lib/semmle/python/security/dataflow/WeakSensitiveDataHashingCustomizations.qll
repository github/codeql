/**
 * Provides default sources, sinks and sanitizers for detecting
 * "use of a broken or weak cryptographic hashing algorithm on sensitive data"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.SensitiveDataSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "use of a broken or weak cryptographic hashing algorithm on sensitive data"
 * vulnerabilities on sensitive data that does NOT require computationally expensive
 * hashing, as well as extension points for adding your own.
 *
 * Also see the `ComputationallyExpensiveHashFunction` module.
 */
module NormalHashFunction {
  /**
   * A data flow source for "use of a broken or weak cryptographic hashing algorithm on
   * sensitive data" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    Source() { not this instanceof ComputationallyExpensiveHashFunction::Source }

    /** Gets the classification of the sensitive data. */
    abstract string getClassification();
  }

  /**
   * A data flow sink for "use of a broken or weak cryptographic hashing algorithm on
   * sensitive data" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the name of the weak hashing algorithm.
     */
    abstract string getAlgorithmName();
  }

  /**
   * A sanitizer for "use of a broken or weak cryptographic hashing algorithm on
   * sensitive data" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of sensitive data, considered as a flow source.
   */
  class SensitiveDataSourceAsSource extends Source, SensitiveDataSource {
    override SensitiveDataClassification getClassification() {
      result = SensitiveDataSource.super.getClassification()
    }
  }

  /** The input to a hashing operation using a weak algorithm, considered as a flow sink. */
  class WeakHashingOperationInputSink extends Sink {
    Cryptography::HashingAlgorithm algorithm;

    WeakHashingOperationInputSink() {
      exists(Cryptography::CryptographicOperation operation |
        algorithm = operation.getAlgorithm() and
        algorithm.isWeak() and
        this = operation.getAnInput()
      )
    }

    override string getAlgorithmName() { result = algorithm.getName() }
  }
}

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "use of a broken or weak cryptographic hashing algorithm on sensitive data"
 * vulnerabilities on sensitive data that DOES require computationally expensive
 * hashing, as well as extension points for adding your own.
 *
 * Also see the `NormalHashFunction` module.
 */
module ComputationallyExpensiveHashFunction {
  /**
   * A data flow source of sensitive data that requires computationally expensive
   * hashing for "use of a broken or weak cryptographic hashing algorithm on sensitive
   * data" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets the classification of the sensitive data. */
    abstract string getClassification();
  }

  /**
   * A data flow sink for sensitive data that requires computationally expensive
   * hashing for "use of a broken or weak cryptographic hashing algorithm on sensitive
   * data" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the name of the weak hashing algorithm.
     */
    abstract string getAlgorithmName();

    /**
     * Holds if this sink is for a computationally expensive hash function (meaning that
     * hash function is just weak in some other regard.
     */
    abstract predicate isComputationallyExpensive();
  }

  /**
   * A sanitizer of sensitive data that requires computationally expensive
   * hashing for "use of a broken or weak cryptographic hashing
   * algorithm on sensitive data" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of passwords, considered as a flow source.
   */
  class PasswordSourceAsSource extends Source, SensitiveDataSource {
    PasswordSourceAsSource() {
      SensitiveDataSource.super.getClassification() = SensitiveDataClassification::password()
    }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataSource.super.getClassification()
    }
  }

  /**
   * The input to a password hashing operation using a weak algorithm, considered as a
   * flow sink.
   */
  class WeakPasswordHashingOperationInputSink extends Sink {
    Cryptography::CryptographicAlgorithm algorithm;

    WeakPasswordHashingOperationInputSink() {
      (
        algorithm instanceof Cryptography::PasswordHashingAlgorithm and
        algorithm.isWeak()
        or
        algorithm instanceof Cryptography::HashingAlgorithm // Note that HashingAlgorithm and PasswordHashingAlgorithm are disjoint
      ) and
      exists(Cryptography::CryptographicOperation operation |
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
