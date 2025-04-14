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
      not SensitiveDataSource.super.getClassification() in [
          SensitiveDataClassification::id(), SensitiveDataClassification::certificate()
        ]
    }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataSource.super.getClassification()
    }
  }

  /** The data written to a file, considered as a flow sink. */
  class FileWriteDataAsSink extends Sink {
    FileWriteDataAsSink() {
      this = any(FileSystemWriteAccess write).getADataNode() and
      // since implementation of Path.write_bytes in pathlib.py is like
      // ```py
      // def write_bytes(self, data):
      //     with self.open(mode='wb') as f:
      //         return f.write(data)
      // ```
      // any time we would report flow to the `Path.write_bytes` sink, we can ALSO report
      // the flow from the `data` parameter to the `f.write` sink -- obviously we
      // don't want that.
      //
      // However, simply removing taint edges out of a sink is not a good enough solution,
      // since we would only flag one of the `p.write` calls in the following example
      // due to use-use flow
      // ```py
      // p.write(user_controlled)
      // p.write(user_controlled)
      // ```
      //
      // The same approach is used in the command injection query.
      not exists(Module pathlib |
        pathlib.getName() = "pathlib" and
        this.getScope().getEnclosingModule() = pathlib and
        // do allow this call if we're analyzing pathlib.py as part of CPython though
        not exists(pathlib.getFile().getRelativePath())
      )
    }
  }

  /** The data written to a cookie on a HTTP response, considered as a flow sink. */
  class CookieWriteAsSink extends Sink {
    CookieWriteAsSink() {
      exists(Http::Server::CookieWrite write |
        this = write.getValueArg()
        or
        this = write.getHeaderArg()
      )
    }
  }
}
