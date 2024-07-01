/**
 * Provides default sources, sinks and sanitizers for detecting
 * "use of a broken or weak cryptographic hashing algorithm on sensitive data"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.security.SensitiveActions
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.SSA

private module SensitiveDataSources {
  /**
   * A data flow source of sensitive data, such as secrets, certificates, or passwords.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `SensitiveDataSource::Range` instead.
   */
  class SensitiveDataSource extends DataFlow::Node instanceof SensitiveDataSource::Range {
    /**
     * Gets the classification of the sensitive data.
     */
    SensitiveDataClassification getClassification() { result = super.getClassification() }
  }

  /** Provides a class for modeling new sources of sensitive data, such as secrets, certificates, or passwords. */
  module SensitiveDataSource {
    /**
     * A data flow source of sensitive data, such as secrets, certificates, or passwords.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `SensitiveDataSource` instead.
     */
    abstract class Range extends DataFlow::Node {
      /**
       * Gets the classification of the sensitive data.
       */
      abstract SensitiveDataClassification getClassification();
    }
  }

  /**
   * A call to a method that may return sensitive data.
   */
  class SensitiveMethodCall extends SensitiveDataSource::Range instanceof SensitiveCall {
    override SensitiveDataClassification getClassification() {
      result = SensitiveCall.super.getClassification()
    }
  }

  /**
   * An assignment to a variable that may contain sensitive data.
   */
  class SensitiveVariableAssignment extends SensitiveDataSource::Range, DataFlow::SsaDefinitionNode {
    SensitiveNode sensitiveNode;

    SensitiveVariableAssignment() {
      this.getDefinition().(Ssa::WriteDefinition).getWriteAccess() = sensitiveNode.asExpr()
    }

    override SensitiveDataClassification getClassification() {
      result = sensitiveNode.getClassification()
    }
  }

  /**
   * A read from a hash value that may return sensitive data.
   */
  class SensitiveHashValueAccess extends SensitiveDataSource::Range instanceof SensitiveNode {
    SensitiveHashValueAccess() {
      this.asExpr() instanceof Cfg::CfgNodes::ExprNodes::ElementReferenceCfgNode
    }

    override SensitiveDataClassification getClassification() {
      result = SensitiveNode.super.getClassification()
    }
  }

  /**
   * A parameter node that may contain sensitive data.
   */
  class SensitiveParameter extends SensitiveDataSource::Range, DataFlow::ParameterNode instanceof SensitiveNode
  {
    override SensitiveDataClassification getClassification() {
      result = SensitiveNode.super.getClassification()
    }
  }
}

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
  class SensitiveDataSourceAsSource extends Source instanceof SensitiveDataSources::SensitiveDataSource
  {
    override SensitiveDataClassification getClassification() {
      result = SensitiveDataSources::SensitiveDataSource.super.getClassification()
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
  class PasswordSourceAsSource extends Source instanceof SensitiveDataSources::SensitiveDataSource {
    PasswordSourceAsSource() {
      this.(SensitiveDataSources::SensitiveDataSource).getClassification() =
        SensitiveDataClassification::password()
    }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataSources::SensitiveDataSource.super.getClassification()
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
