/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * writing user-controlled data to files, as well as extension points
 * for adding your own.
 */

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * writing user-controlled data to files, as well as extension points
 * for adding your own.
 */
module HttpToFileAccess {
  import HttpToFileAccessSpecific

  /**
   * A data flow source for writing user-controlled data to files.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for writing user-controlled data to files.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for writing user-controlled data to files.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A sink that represents file access method (write, append) argument */
  class FileAccessAsSink extends Sink {
    FileAccessAsSink() { exists(FileSystemWriteAccess src | this = src.getADataNode()) }
  }
}
