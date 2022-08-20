/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * cleartext storage of sensitive information, as well as extension points for
 * adding your own.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import internal.CleartextSources

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * cleartext storage of sensitive information, as well as extension points for
 * adding your own.
 */
module CleartextStorage {
  /**
   * A data flow source for cleartext storage of sensitive information.
   */
  class Source = CleartextSources::Source;

  /**
   * A sanitizer for cleartext storage of sensitive information.
   */
  class Sanitizer = CleartextSources::Sanitizer;

  /** Holds if `nodeFrom` taints `nodeTo`. */
  predicate isAdditionalTaintStep = CleartextSources::isAdditionalTaintStep/2;

  /**
   * A data flow sink for cleartext storage of sensitive information.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A node representing data written to the filesystem.
   */
  private class FileSystemWriteAccessDataNodeAsSink extends Sink {
    FileSystemWriteAccessDataNodeAsSink() { this = any(FileSystemWriteAccess write).getADataNode() }
  }

  /**
   * A node representing data written to a persistent data store.
   */
  private class PersistentWriteAccessAsSink extends Sink {
    PersistentWriteAccessAsSink() { this = any(PersistentWriteAccess write).getValue() }
  }
}
