/**
 * Provides default sources, sinks and sanitizers for detecting
 * "path injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, and sinks for detecting
 * "path injection"
 * vulnerabilities, as well as extension points for adding your own.
 *
 * Since the path-injection configuration setup is rather complicated, we do not
 * expose a `Sanitizer` class, and instead you should extend
 * `Path::PathNormalization::Range` and `Path::SafeAccessCheck::Range` from
 * `semmle.python.Concepts` instead.
 */
module PathInjection {
  /**
   * A data flow source for "path injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "path injection" vulnerabilities.
   * Such as a file system access.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "path injection" vulnerabilities.
   *
   * This should only be used for things like calls to library functions that perform their own
   * (correct) normalization/escaping of untrusted paths.
   *
   * Please also see `Path::SafeAccessCheck` and `Path::PathNormalization` Concepts.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A file system access, considered as a flow sink.
   */
  class FileSystemAccessAsSink extends Sink {
    FileSystemAccessAsSink() {
      this = any(FileSystemAccess e).getAPathArgument() and
      // since implementation of Path.open in pathlib.py is like
      // ```py
      // def open(self, ...):
      //     return io.open(self, ...)
      // ```
      // any time we would report flow to the `path_obj.open` sink, we can ALSO report
      // the flow from the `self` parameter to the `io.open` sink -- obviously we
      // don't want that.
      //
      // However, simply removing taint edges out of a sink is not a good enough solution,
      // since we would only flag one of the `p.open` calls in the following example
      // due to use-use flow
      // ```py
      // p.open()
      // p.open()
      // ```
      //
      // The same approach is used in the command injection query.
      not exists(Module inStdlib |
        inStdlib.getName() in ["pathlib", "os"] and
        this.getScope().getEnclosingModule() = inStdlib and
        // do allow this call if we're analyzing, say, pathlib.py as part of CPython though
        not exists(inStdlib.getFile().getRelativePath())
      )
    }
  }

  private import semmle.python.frameworks.data.ModelsAsData

  private class DataAsFileSink extends Sink {
    DataAsFileSink() { this = ModelOutput::getASinkNode("path-injection").asSink() }
  }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }

  /** DEPRECATED: Use ConstCompareAsSanitizerGuard instead. */
  deprecated class StringConstCompareAsSanitizerGuard = ConstCompareAsSanitizerGuard;
}
