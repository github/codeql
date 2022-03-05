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
   * A node representing data written to a database using an ORM system.
   */
  private class OrmWriteAccessValueAsSink extends Sink {
    //  instanceof OrmWriteAccess {
    // TODO: we generally won't get flow from `value` to `this`
    // Should the node be on value? Or should there be an additional flow step from
    // value to the write node?
    OrmWriteAccessValueAsSink() {
      exists(OrmWriteAccess write, string fieldName |
        fieldName = write.getFieldNameAssignedTo(this)
      )
    }
  }
}
