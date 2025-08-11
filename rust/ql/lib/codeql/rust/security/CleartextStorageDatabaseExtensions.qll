/**
 * Provides classes and predicates for reasoning about cleartext storage
 * of sensitive information in a database.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.security.SensitiveData
private import codeql.rust.Concepts

/**
 * Provides default sources, sinks and barriers for detecting cleartext storage
 * of sensitive information in a database, as well as extension points for
 * adding your own.
 */
module CleartextStorageDatabase {
  /**
   * A data flow source for cleartext storage vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for cleartext storage vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "CleartextStorageDatabase" }
  }

  /**
   * A barrier for cleartext storage vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * Sensitive data, considered as a flow source.
   */
  private class SensitiveDataAsSource extends Source instanceof SensitiveData { }

  /**
   * A sink for cleartext storage vulnerabilities from model data.
   *  - SQL commands
   *  - other database storage operations
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, ["sql-injection", "database-store"]) }
  }
}
