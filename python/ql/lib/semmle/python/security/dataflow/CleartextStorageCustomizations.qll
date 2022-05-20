/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Clear-text storage of sensitive information"
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
 * "Clear-text storage of sensitive information"
 * vulnerabilities, as well as extension points for adding your own.
 */
module CleartextStorage {
  /**
   * A data flow source for "Clear-text storage of sensitive information" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets the classification of the sensitive data. */
    abstract string getClassification();
  }

  /**
   * A data flow sink for "Clear-text storage of sensitive information" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "Clear-text storage of sensitive information" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of sensitive data, considered as a flow source.
   */
  class SensitiveDataSourceAsSource extends Source, SensitiveDataSource {
    SensitiveDataSourceAsSource() {
      not SensitiveDataSource.super.getClassification() = SensitiveDataClassification::id()
    }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataSource.super.getClassification()
    }
  }

  /** The data written to a file, considered as a flow sink. */
  class FileWriteDataAsSink extends Sink {
    FileWriteDataAsSink() { this = any(FileSystemWriteAccess write).getADataNode() }
  }

  /** The data written to a cookie on a HTTP response, considered as a flow sink. */
  class CookieWriteAsSink extends Sink {
    CookieWriteAsSink() {
      exists(HTTP::Server::CookieWrite write |
        this = write.getValueArg()
        or
        this = write.getHeaderArg()
      )
    }
  }
}
